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
    
    let mapListener = RouteMapEventListener()
    let selectListener = VectorObjectClickListener()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = contentView
        
        routing = Routing(mapView: contentView.map)
        routing.showTurns = false
        
        selectListener?.source = contentView.popupSource
        
        let projection = contentView.baseSource.getProjection()
        let washingtonDC = projection?.fromWgs84(NTMapPos(x: -77.0369, y: 38.9072))
        contentView.map.setFocus(washingtonDC, durationSeconds: 0)
        contentView.map.setZoom(14, durationSeconds: 0)
        
        routing.service = NTValhallaOnlineRoutingService(apiKey: BaseGeocodingController.API_KEY)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.map.setMapEventListener(mapListener)
        mapListener?.delegate = self
        
        contentView.overlayLayer.setVectorElementEventListener(selectListener)
        
        let text = "Long-click on the map to set a route point"
        contentView.banner.showInformation(text: text, autoclose: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.map.setMapEventListener(nil)
        mapListener?.delegate = nil
        
        contentView.overlayLayer.setVectorElementEventListener(nil)
    }
    
    func startClicked(event: RouteMapEvent) {
        self.routing.setStartMarker(position: event.clickPosition)
    }
    
    func stopClicked(event: RouteMapEvent) {
        routing.setStopMarker(position: event.clickPosition)
        showRoute(start: event.startPosition, stop: event.stopPosition)
    }
    
    func singleTap() {
        contentView.popupSource.clear()
    }

    func showRoute(start: NTMapPos, stop: NTMapPos) {
        
        DispatchQueue.global().async {
            
            let result = self.routing.getResult(startPos: start, stopPos: stop)
            
            if (result == nil) {
                DispatchQueue.main.async {
                    self.contentView.banner.showInformation(text: "Routing failed. Please try again", autoclose: true)
                }
                return
            }
            
            let color = NTColor(r: 14, g: 122, b: 254, a: 150)
            DispatchQueue.main.async {
                
                let text = self.routing.getMessage(result: result!)
                self.contentView.banner.showInformation(text: text, autoclose: true)
                self.routing.show(result: result!, lineColor: color!, complete: {_ in })
            
                let collection = self.routing.routeDataSource?.getFeatureCollection()
                let count = Int((collection?.getFeatureCount())!)
                
                self.contentView.overlaySource.clear()
                
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





