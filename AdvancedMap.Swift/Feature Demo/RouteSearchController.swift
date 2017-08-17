//
//  RouteSearchController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 17/08/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class RouteSearchController : BaseController, RouteMapEventDelegate {
    
    let contentView = RouteSearchView()
    var routing: Routing!
    
    let listener = RouteMapEventListener()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = contentView
        
        routing = Routing(mapView: contentView.map)
        routing.showTurns = false
        
        let source = Routing.ONLINE_ROUTING_SOURCE + Routing.TRANSPORT_MODE
        routing.service = NTCartoOnlineRoutingService(source: source)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.map.setMapEventListener(listener)
        listener?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.map.setMapEventListener(nil)
        listener?.delegate = nil
    }
    
    func startClicked(event: RouteMapEvent) {
        self.routing.setStartMarker(position: event.clickPosition)
    }
    
    func stopClicked(event: RouteMapEvent) {
        routing.setStopMarker(position: event.clickPosition)
        showRoute(start: event.startPosition, stop: event.stopPosition)
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
        request?.setProjection(contentView.baseSource.getProjection())
        request?.setGeometry(geometry)
        request?.setSearchRadius(500.0)
        request?.setFilterExpression("class='attraction'")
        
        let results = contentView.searchService.findFeatures(request)
        let count = Int((results?.getFeatureCount())!)
        
        for i in 0..<count {
            let item = results?.getFeature(Int32(i))!
            
            if (item?.getGeometry() is NTPointGeometry) {
                contentView.addPOI(feature: item!)
            }
        }
    }
}





