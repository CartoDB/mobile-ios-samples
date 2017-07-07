//
//  ReverseGeocodingController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 06/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class ReverseGecodingController : BaseController, ReverseGeocodingEventDelegate {
    
    var contentView: ReverseGeocodingView!
    
    var listener: ReverseGeocodingEventListener!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = ReverseGeocodingView()
        view = contentView
        
        listener = ReverseGeocodingEventListener()
        listener.projection = contentView.projection
        
        let path = Bundle.main.path(forResource: "estonia-latest", ofType: "sqlite")
        listener.service = NTOSMOfflineReverseGeocodingService(path: path)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        
        listener.delegate = self
        
        contentView.map.setMapEventListener(listener)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        listener.delegate = nil
        
        contentView.map.setMapEventListener(nil)
    }
    
    func foundResult(result: NTGeocodingResult!) {
        
        contentView.source.clear()
        
        let builder = NTBalloonPopupStyleBuilder()
        builder?.setLeftMargins(NTBalloonPopupMargins(left: 0, top: 0, right: 0, bottom: 0))
        builder?.setTitleMargins(NTBalloonPopupMargins(left: 6, top: 3, right: 6, bottom: 3))
        builder?.setCornerRadius(5)
        
        // Make sure this label is shown on top of all other labels
        builder?.setPlacementPriority(10)
        
        let collection = result.getFeatureCollection()
        let count = Int((collection?.getFeatureCount())!)
        
        var position: NTMapPos?
        
        for var i in 0..<count {
            
            let geometry = collection?.getFeature(Int32(i)).getGeometry()
            let color = NTColor(r: 0, g: 100, b: 200, a: 150)
            
            // Build styles for the displayed geometry
            let pointBuilder = NTPointStyleBuilder()
            pointBuilder?.setColor(color)
            
            let lineBuilder = NTLineStyleBuilder()
            lineBuilder?.setColor(color)
            
            let polygonBuilder = NTPolygonStyleBuilder()
            polygonBuilder?.setColor(color)
            
            var element: NTVectorElement?
            
            if let pointGeometry = geometry as? NTPointGeometry {
                element = NTPoint(geometry: pointGeometry, style: pointBuilder?.buildStyle())
                
            } else if let lineGeometry = geometry as? NTLineGeometry {
                element = NTLine(geometry: lineGeometry, style: lineBuilder?.buildStyle())
            } else if let polygonGeometry = geometry as? NTPolygonGeometry {
                element = NTPolygon(geometry: polygonGeometry, style: polygonBuilder?.buildStyle())
                
            } else if let multiGeometry = geometry as? NTMultiGeometry {
                
                let collectionBuilder = NTGeometryCollectionStyleBuilder()
                collectionBuilder?.setPointStyle(pointBuilder?.buildStyle())
                collectionBuilder?.setLineStyle(lineBuilder?.buildStyle())
                collectionBuilder?.setPolygonStyle(polygonBuilder?.buildStyle())
                
                element = NTGeometryCollection(geometry: multiGeometry, style: collectionBuilder?.buildStyle())
            }
            
            position = geometry?.getCenterPos()
            contentView.source.add(element)

            i += 1
        }
        
        let title = ""
        var description = "No address found"
        
        if (result != nil) {
            description = result.description()
        }
        
        let popup = NTBalloonPopup(pos: position, style: builder?.buildStyle(), title: title, desc: description)
        contentView.source.add(popup)
    }
}
        







