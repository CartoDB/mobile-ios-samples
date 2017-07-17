//
//  BaseGeocodingView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 07/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class BaseGeocodingView: PackageDownloadBaseView {
    
    static let SOURCE = "geocoding:carto.geocode"
    
    var source: NTLocalVectorDataSource!
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func initializeGeocodingView(popupTitle: String, popupDescription: String) {
        
        onlineLayer = addBaseLayer()
        
        initialize()
        initializeDownloadContent()
        initializePackageDownloadContent()
        
        infoContent.setText(headerText: popupTitle, contentText: popupDescription)
        
        source = NTLocalVectorDataSource(projection: projection)
        let layer = NTVectorLayer(dataSource: source)
        
        map.getLayers().add(layer)
        
        let position = projection?.fromWgs84(NTMapPos(x: 26.7, y: 58.38))
        map.setFocus(position, durationSeconds: 0)
        map.setZoom(14.5, durationSeconds: 0)
        
        hideSwitch()
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
            
            let min = NTScreenPos(x: 10, y: 10)
            let max = NTScreenPos(x: Float(map.drawableWidth - 20), y: Float(map.drawableHeight - 20))
            let bounds = NTScreenBounds(min: min, max: max)
            
            map.move(toFit: geometry?.getBounds(), screenBounds: bounds, integerZoom: false, durationSeconds: 0.5)
        }
        
        let popup = NTBalloonPopup(pos: position, style: builder?.buildStyle(), title: title, desc: description)
        source.add(popup)
    }
}








