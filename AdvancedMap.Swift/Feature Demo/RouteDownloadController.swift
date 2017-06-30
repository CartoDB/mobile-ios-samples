//
//  StyleChoiceController.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import  UIKit

class RouteDownloadController : BaseController, PackageDownloadDelegate, RouteMapEventDelegate, SwitchDelegate {
    
    var routing: Routing!
    
    var contentView: RouteDownloadView!
    
    var boundingBox: BoundingBox!
    
    var mapPackageListener: MapPackageListener!
    var routingPackageListener : RoutingPackageListener!
    
    var routingManager: NTCartoPackageManager!
    var mapManager: NTCartoPackageManager!
    
    var mapListener: RouteMapEventListener!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        contentView = RouteDownloadView()
        
        view = contentView
        
        routing = Routing(mapView: contentView.map)
        
        var folder = Utils.createDirectory(name: "mappackages")
        mapManager = NTCartoPackageManager(source: Routing.MAP_SOURCE, dataFolder: folder)
        
        folder = Utils.createDirectory(name: "routingpackages")
        routingManager = NTCartoPackageManager(source: Routing.ROUTING_TAG + Routing.ROUTING_SOURCE, dataFolder: folder)
        
        setOnlineMode()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.downloadButtonTapped(_:)))
        contentView.downloadButton.addGestureRecognizer(recognizer)
        
        let mapPackages = mapManager.getLocalPackages()
        let routingPackages = routingManager.getLocalPackages()
        
        var existing = [NTPackageInfo]()
        
        let mapPackageCount = Int((mapPackages?.size())!)
        let routingPackageCount = Int((routingPackages?.size())!)
        
        // Ensure both map package and routing package exist before adding them
        for i in stride(from: 0, to: mapPackageCount, by: 1) {
            
            let mapPackage = mapPackages?.get(Int32(i))
            
            for j in stride(from: 0, to: routingPackageCount, by: 1) {
                
                let routingPackage = routingPackages?.get(Int32(j))
                
                if (mapPackage?.getPackageId().contains((routingPackage?.getPackageId())!))! {
                    existing.append(mapPackage!)
                }
            }
        }
        
        contentView.addPolygonsTo(packageList: existing)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        
        mapListener = RouteMapEventListener()
        mapListener.delegate = self
        contentView.map.setMapEventListener(mapListener)
        
        mapPackageListener = MapPackageListener()
        mapPackageListener.delegate = self
        mapManager.setPackageManagerListener(mapPackageListener)
        mapManager.start()
        
        routingPackageListener = RoutingPackageListener()
        routingPackageListener.delegate = self
        routingManager.setPackageManagerListener(routingPackageListener)
        routingManager.start()
        
        contentView.onlineSwitch.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        mapListener = nil
        
        mapManager.stop(true)
        mapPackageListener = nil
        
        routingManager.stop(true)
        routingPackageListener = nil
        
        contentView.onlineSwitch.delegate = nil
    }
    
    func downloadButtonTapped(_ sender: UITapGestureRecognizer) {
        
        let id = boundingBox.toString()
        mapManager.startPackageDownload(id)
    }
    
    func switchChanged() {
        
        if (contentView.onlineSwitch.isOn()) {
            setOnlineMode()
        } else {
            setOfflineMode()
        }
    }
    
    func setOnlineMode() {
        routing.service = NTCartoOnlineRoutingService(source: Routing.MAP_SOURCE + Routing.TRANSPORT_MODE)
    }
    
    func setOfflineMode() {
        
        /*
         * If you ended up with a build error here, NTPackageManagerValhallaRoutingService not found,
         * then you should know that AdvancedMap.Swift requires CartoMobileSDK 4.1.0 Valhalla build,
         * which is not yet (as of 26 June 2017) on cocoapods, because cocoapods do not support semantic versioning
         * 
         * Download the latest development build from:
         * https://nutifront.s3.amazonaws.com/sdk_snapshots/sdk4-ios-4.1.0-dev-latest.zip
         * unzip it and simply replace CartMobileSDk.framework file in AdvancedMap.Swift/Pods/CartoMobileSDK
         */
        routing.service = NTPackageManagerValhallaRoutingService(packageManager: routingManager)
    }
    
    func startClicked(event: RouteMapEvent) {
        DispatchQueue.main.async(execute: {
            self.routing.setStartMarker(position: event.clickPosition)
            self.contentView.downloadButton.disable()
            self.contentView.progressLabel.hide()
        })
    }
    
    func stopClicked(event: RouteMapEvent) {
        routing.setStopMarker(position: event.clickPosition)
        showRoute(start: event.startPosition, stop: event.stopPosition)
    }
    
    func showRoute(start: NTMapPos, stop: NTMapPos) {
        DispatchQueue.global().async {
            
            let result: NTRoutingResult? = self.routing.getResult(startPos: start, stopPos: stop)
            
            DispatchQueue.main.async(execute: {
                
                if (result == nil) {
                    self.contentView.progressLabel.complete(message: "Routing failed. Please try again")
                    return
                } else {
                    self.contentView.progressLabel.complete(message: self.routing.getMessage(result: result!))
                }
                
                let color = NTColor(r: 14, g: 122, b: 254, a: 150)
                self.routing.show(result: result!, lineColor: color!, complete: {
                    (route: Route) in
                    
                    let projection = self.contentView.map.getOptions().getBaseProjection()
                    self.boundingBox = BoundingBox.fromMapBounds(projection: projection!, bounds: route.bounds!, extraMeters: 0)
                    
                    self.contentView.downloadButton.enable()
                    
                    if (!self.contentView.progressLabel.isVisible()) {
                        self.contentView.progressLabel.show()
                    }
                })
            })
        }
    }
    
    func listDownloadComplete() {
        // No implementation
    }
    
    func listDownloadFailed() {
        // No implemenetation
    }
    
    func downloadComplete(sender: PackageListener, id: String) {
        
        if (type(of: sender) == MapPackageListener.self) {
            routingManager.startPackageDownload(id)
        } else {
            let bounds = boundingBox.bounds
            
            DispatchQueue.main.async(execute: {
                self.contentView.addPolygonTo(bounds: bounds!)
            })
        }
    }
    
    func downloadFailed(sender: PackageListener, errorType: NTPackageErrorType) {
        
        var text = ""
        
        if (type(of: sender) == MapPackageListener.self) {
            text = "Map download failed"
        } else {
            text = "Route download failed"
        }
        
        DispatchQueue.main.async(execute: {
            self.contentView.progressLabel.complete(message: text)
        })
    }
    
    func statusChanged(sender: PackageListener, status: NTPackageStatus) {
        
        let progress = CGFloat(status.getProgress())
        var text = "Downloading map: " + String(describing: progress) + "%"
 
        if (type(of: sender) == RoutingPackageListener.self) {
            text = "Downloading route: " + String(describing: progress) + "%"
        }
        
        DispatchQueue.main.async(execute: {
            self.contentView.progressLabel.update(text: text, progress: progress)
        })
    }

}






