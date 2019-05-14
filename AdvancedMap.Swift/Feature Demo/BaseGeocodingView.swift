//
//  BaseGeocodingView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 07/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import CartoMobileSDK

class BaseGeocodingView: PackageDownloadBaseView {
    
    static let PACKAGE_FOLDER = "geocodingpackages"
    
    static let SOURCE = "geocoding:carto.streets"
    
    var source: NTLocalVectorDataSource!
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func initializeGeocodingView(popupTitle: String, popupDescription: String) {
        
        initialize()
        initializeDownloadContent(withSwitch: true)
        initializePackageDownloadContent()
        
        infoContent.setText(headerText: popupTitle, contentText: popupDescription)
        
        source = NTLocalVectorDataSource(projection: projection)
        let layer = NTVectorLayer(dataSource: source)
        
        map.getLayers().add(layer)
    }
    
    func showResult(result: NTGeocodingResult!, title: String, description: String, goToPosition: Bool) {
        
        source.clear()
        
        let builder = NTBalloonPopupStyleBuilder()
        builder?.setLeftMargins(NTBalloonPopupMargins(left: 0, top: 0, right: 0, bottom: 0))
        builder?.setTitleMargins(NTBalloonPopupMargins(left: 6, top: 3, right: 6, bottom: 3))
        builder?.setCornerRadius(5)
        
        // Make sure this label is shown on top of all other labels
        builder?.setPlacementPriority(10)
        
        let collection = result.getFeatureCollection()
        let count = Int((collection?.getFeatureCount())!)
        
        var position: NTMapPos?
        
        var geometry: NTGeometry?
        
        for var i in 0..<count {
            
            geometry = collection?.getFeature(Int32(i)).getGeometry()
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
            source.add(element)
            
            i += 1
        }
        
        if (goToPosition) {
            map.setFocus(position, durationSeconds: 1.0)
            map.setZoom(16, durationSeconds: 1)
        }
        
        let popup = NTBalloonPopup(pos: position, style: builder?.buildStyle(), title: title, desc: description)
        source.add(popup)
    }
}








