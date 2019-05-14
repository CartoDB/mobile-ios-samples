//
//  LocationMarker.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 09/10/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import CoreLocation
import CartoMobileSDK

class LocationMarker: NSObject {
    
    var map: NTMapView!
    
    var source: NTLocalVectorDataSource!
    var projection: NTProjection!
    
    init(mapView: NTMapView) {
        super.init()
        self.map = mapView
        
        projection = self.map.getOptions().getBaseProjection()
        source = NTLocalVectorDataSource(projection: projection)
        let layer = NTVectorLayer(dataSource: source)
        map.getLayers().add(layer)
    }
    
    var userMarker: NTPoint!
    var accuracyMarker: NTPolygon!
    var navigationPointer: NTMarker!
    
    var focus = true
    var isNavigationPointer = false
    
    func showAt(location: CLLocation) {
        
        let latitude = Double(location.coordinate.latitude)
        let longitude = Double(location.coordinate.longitude)
        let accuracy = Float(location.horizontalAccuracy)
        
        showAt(latitude: latitude, longitude: longitude, accuracy: accuracy)
    }
    
    func showAt(latitude: Double, longitude: Double, accuracy: Float) {
        
        let position = projection?.fromWgs84(NTMapPos(x: longitude, y: latitude))
        
        if (focus) {
            map.setFocus(position, durationSeconds: 1)
            map.setZoom(16, durationSeconds: 1)
        }
        
        if (isNavigationPointer) {
            
            if (navigationPointer == nil) {
                let builder = NTMarkerStyleBuilder()
                builder?.setBitmap(Utils.pathToBitmap(path: "icon_navigation_pointer.png"))
                builder?.setSize(25.0)
                builder?.setAnchorPointX(0, anchorPointY: 0)
                builder?.setOrientationMode(.BILLBOARD_ORIENTATION_FACE_CAMERA_GROUND)
                navigationPointer = NTMarker(pos: position, style: builder?.buildStyle())
                
                source.add(navigationPointer)
            }
            
            navigationPointer.setPos(position)
            
            return
        }
        
        let builder = NTPolygonStyleBuilder()
        builder?.setColor(Colors.lightTransparentAppleBlue.toNTColor())
        let borderBuilder = NTLineStyleBuilder()
        borderBuilder?.setColor(Colors.darkTransparentAppleBlue.toNTColor())
        borderBuilder?.setWidth(1)
        
        builder?.setLineStyle(borderBuilder?.buildStyle())
        
        let points = getCirclePoints(latitude: latitude, longitude: longitude, accuracy: accuracy)
        
        if (accuracyMarker == nil) {
            accuracyMarker = NTPolygon(poses: points, holes: NTMapPosVectorVector(), style: builder?.buildStyle())
            source.add(accuracyMarker)
        } else {
            accuracyMarker.setStyle(builder?.buildStyle())
            accuracyMarker.setGeometry(NTPolygonGeometry(poses: points))
        }
        
        if (userMarker == nil) {
            let builder = NTPointStyleBuilder()
            builder?.setColor(Colors.appleBlue.toNTColor())
            builder?.setSize(16.0)
            
            userMarker = NTPoint(pos: position, style: builder?.buildStyle())
            source.add(userMarker)
        }
        
        userMarker.setPos(position)
    }
    
    func rotate(rotation: Float) {
        
        if (navigationPointer == nil) {
            return
        }
        
        navigationPointer.setRotation(rotation)
    }
    
    func getCirclePoints(latitude: Double, longitude: Double, accuracy: Float) -> NTMapPosVector {
        // Number of points of circle
        let N = 100
        let EARTH_RADIUS = 6378137.0
        
        let radius = Double(accuracy)
        
        let points = NTMapPosVector()
        
        for i in stride(from: 0, to: N, by: 1) {
            
            let angle = Double.pi * 2 * (Double(i).truncatingRemainder(dividingBy:Double(N))) / Double(N)
            let dx = radius * cos(angle)
            let dy = radius * sin(angle)
            
            let lat = latitude + (180 / Double.pi) * (dy / EARTH_RADIUS)
            let lon = longitude + (180 / Double.pi) * (dx / EARTH_RADIUS) / cos(Double(latitude * Double.pi / 180))
            
            let point = projection.fromWgs84(NTMapPos(x: lon, y: lat))
            points?.add(point)
        }
        
        return points!
    }

}






