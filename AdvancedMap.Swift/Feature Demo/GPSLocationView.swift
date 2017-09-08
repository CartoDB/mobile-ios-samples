//
//  GPSLocationView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 28/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class GPSLocationView : MapBaseView {
    
    var baseLayer: NTCartoOnlineVectorTileLayer!
    
    var switchButton: SwitchButton!
    
    var source: NTLocalVectorDataSource!
    
    var projection: NTProjection!
    
    let rotationResetButton = RotationResetButton()
    let scaleBar = ScaleBar()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        initialize()
        baseLayer = addBaseLayer()

        infoContent.setText(headerText: Texts.gpsLocationInfoHeader, contentText: Texts.gpsLocationInfoContainer)
        
        projection = map.getOptions().getBaseProjection()
        source = NTLocalVectorDataSource(projection: projection)
        let layer = NTVectorLayer(dataSource: source)
        map.getLayers().add(layer)
        
        switchButton = SwitchButton(onImageUrl: "icon_track_location_on.png", offImageUrl: "icon_track_location_off.png")
        addButton(button: switchButton)
        
        rotationResetButton.resetDuration = rotationDuration
        addSubview(rotationResetButton)
        
        scaleBar.map = map
        addSubview(scaleBar)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 5
        let scaleBarPadding = padding * 3;
        
        var width: CGFloat = 50
        var height = width
        var x = frame.width - (width + padding)
        var y = Device.trueY0() + padding
        
        rotationResetButton.frame = CGRect(x: x, y: y, width: width, height: height)
        
        width = frame.width / 5
        height = 20
        y = frame.height - (height + scaleBarPadding)
        x = frame.width - (width + scaleBarPadding)
        
        scaleBar.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func addRecognizers() {
        super.addRecognizers()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.rotationButtonTapped(_:)))
        rotationResetButton.addGestureRecognizer(recognizer)
    }
    
    override func removeRecognizers() {
        super.removeRecognizers()
        rotationResetButton.gestureRecognizers?.forEach(rotationResetButton.removeGestureRecognizer)
    }
    
    let rotationDuration: Float = 0.4
    var isRotationInProgress = false
    
    func rotationButtonTapped(_ sender: UITapGestureRecognizer) {
        isRotationInProgress = true
        map.setRotation(0, durationSeconds: rotationDuration)
        rotationResetButton.reset()
        Timer.scheduledTimer(timeInterval: TimeInterval(rotationDuration + 0.1), target: self, selector: #selector(onRotationCompleted), userInfo: nil, repeats: false)
    }
    
    func onRotationCompleted() {
        isRotationInProgress = false
    }
    
    var userMarker: NTPoint!
    var accuracyMarker: NTPolygon!
    
    func showUserAt(location: CLLocation) {
        
        let latitude = Double(location.coordinate.latitude)
        let longitude = Double(location.coordinate.longitude)
        let accuracy = Float(location.horizontalAccuracy)
        
        let position = projection?.fromWgs84(NTMapPos(x: longitude, y: latitude))
        
        map.setFocus(position, durationSeconds: 1)
        map.setZoom(16, durationSeconds: 1)
        
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
    
    func resetMapRotation() {
        map.setRotation(0, durationSeconds: 0.5)
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










