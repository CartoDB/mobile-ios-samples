//
//  OfflineRoutingController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 04/08/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class OfflineRoutingController: BasePackageDownloadController, RouteMapEventDelegate {
    
    var routing: Routing!
    
    var mapListener: RouteMapEventListener!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = OfflineRoutingView()
        view = contentView
        
        routing = Routing(mapView: contentView.map)
        
        let folder = Utils.createDirectory(name: PackageDownloadBaseView.ROUTING_FOLDER)
        contentView.manager = NTCartoPackageManager(source: Routing.ROUTING_TAG + Routing.OFFLINE_ROUTING_SOURCE, dataFolder: folder)
        
        setOnlineMode()
        
        mapListener = RouteMapEventListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapListener.delegate = self
        contentView.map.setMapEventListener(mapListener)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mapListener.delegate = nil
        contentView.map.setMapEventListener(nil)
    }
    
    func singleTap() {
        // No actions for single tap
    }
    
    override func downloadComplete(sender: PackageListener, id: String) {
        
        contentView.downloadComplete(id: id)
        
        DispatchQueue.main.async {
            let package = self.contentView.manager?.getLocalPackage(id)
            
            if (package == nil) {
                return;
            }
            
            var name = package?.getName()
            let id = package?.getPackageId()
            
            if (id?.contains(Package.BBOX_IDENTIFIER))! {
                name = Cities.findNameById(id: (package?.getPackageId())!)
            }
            
            let text = "DOWNLOADED (" + name! + String(describing: (package?.getSizeInMB())!) + "MB)"
            self.contentView.progressLabel.complete(message: text)
        }
    }

    func startClicked(event: RouteMapEvent) {
        DispatchQueue.main.async(execute: {
            self.routing.setStartMarker(position: event.clickPosition)
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
                    
                })
            })
        }
    }
    
    override func setOnlineMode() {
        super.setOnlineMode()
        routing.service = NTCartoOnlineRoutingService(source: Routing.ONLINE_ROUTING_SOURCE + Routing.TRANSPORT_MODE)
    }
    
    override func setOfflineMode() {
        super.setOfflineMode()
        routing.service = NTPackageManagerValhallaRoutingService(packageManager: contentView.manager)
    }
    
}



