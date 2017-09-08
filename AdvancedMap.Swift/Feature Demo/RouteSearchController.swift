//
//  RouteSearchController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 17/08/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class RouteSearchController : BasePackageDownloadController, RouteMapEventDelegate {
    
    var routing: Routing!
    
    let mapListener = RouteMapEventListener()
    let selectListener = VectorObjectClickListener()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = RouteSearchView()
        view = contentView
        
        routing = Routing(mapView: contentView.map)
        routing.showTurns = false
        
        selectListener?.source = (contentView as! RouteSearchView).popupSource
        
        let folder = Utils.createDirectory(name: PackageDownloadBaseView.ROUTING_FOLDER)
        contentView.manager = NTCartoPackageManager(source: Routing.ROUTING_TAG + Routing.OFFLINE_ROUTING_SOURCE, dataFolder: folder)
        
        setOnlineMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.map.setMapEventListener(mapListener)
        mapListener?.delegate = self
        
        (contentView as! RouteSearchView).overlayLayer.setVectorElementEventListener(selectListener)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.map.setMapEventListener(nil)
        mapListener?.delegate = nil
        
        (contentView as! RouteSearchView).overlayLayer.setVectorElementEventListener(nil)
    }
    
    func startClicked(event: RouteMapEvent) {
        self.routing.setStartMarker(position: event.clickPosition)
    }
    
    func stopClicked(event: RouteMapEvent) {
        routing.setStopMarker(position: event.clickPosition)
        showRoute(start: event.startPosition, stop: event.stopPosition)
    }
    
    func singleTap() {
        (contentView as! RouteSearchView).popupSource.clear()
    }
    
    override func setOnlineMode() {
        super.setOnlineMode()
        routing.service = NTValhallaOnlineRoutingService(apiKey: BaseGeocodingController.API_KEY)
        
    }
    
    override func setOfflineMode() {
        super.setOfflineMode()
        routing.service = NTPackageManagerValhallaRoutingService(packageManager: contentView.manager)
    }
    
    func showRoute(start: NTMapPos, stop: NTMapPos) {
        
        DispatchQueue.global().async {
            
            let result = self.routing.getResult(startPos: start, stopPos: stop)
            
            if (result == nil) {
                DispatchQueue.main.async {
                    self.contentView.banner.show(text: "Routing failed. Please try again")
                }
                return
            }
            
            let color = NTColor(r: 14, g: 122, b: 254, a: 150)
            DispatchQueue.main.async {
                
                self.contentView.banner.show(text: self.routing.getMessage(result: result!))
                self.routing.show(result: result!, lineColor: color!, complete: {_ in })
            
                let collection = self.routing.routeDataSource?.getFeatureCollection()
                let count = Int((collection?.getFeatureCount())!)
            
                for i in 0..<count {
                    let item = collection?.getFeature(Int32(i))
                
                    if (item?.getGeometry() is NTLineGeometry) {
                    
                        DispatchQueue.global().async {
                            self.showAttractions(geometry: (item?.getGeometry())!)
                        }
                    }
                }
 
            }
        }
    }
    
    func showAttractions(geometry: NTGeometry) {
        
        let request = NTSearchRequest()
        request?.setProjection((contentView as! RouteSearchView).baseSource.getProjection())
        request?.setGeometry(geometry)
        request?.setSearchRadius(500.0)
        request?.setFilterExpression("class='attraction'")
        
        let results = (contentView as! RouteSearchView).searchService.findFeatures(request)
        let count = Int((results?.getFeatureCount())!)
        
        for i in 0..<count {
            let item = results?.getFeature(Int32(i))!
            
            if (item?.getGeometry() is NTPointGeometry) {
                (contentView as! RouteSearchView).addPOI(feature: item!)
            }
        }
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
}




