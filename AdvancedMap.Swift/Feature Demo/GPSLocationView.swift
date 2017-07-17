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
    
    var topContainer: UIView!
    var stateSwitch: StateSwitch!
    
    var source: NTLocalVectorDataSource!
    
    var projection: NTProjection!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        baseLayer = addBaseLayer()
        
        initialize()
        infoContent.setText(headerText: Texts.gpsLocationInfoHeader, contentText: Texts.gpsLocationInfoContainer)
        
        projection = map.getOptions().getBaseProjection()
        source = NTLocalVectorDataSource(projection: projection)
        let layer = NTVectorLayer(dataSource: source)
        map.getLayers().add(layer)
        
        topContainer = UIView()
        addSubview(topContainer)
        
        stateSwitch = StateSwitch()
        topContainer.addSubview(stateSwitch)
        
        topContainer.backgroundColor = stateSwitch.backgroundColor
        stateSwitch.backgroundColor = Colors.transparent
        stateSwitch.setText(text: "TRACK LOCATION")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height: CGFloat = 45
        
        let x: CGFloat = 0
        var y: CGFloat = Device.trueY0()
        var w: CGFloat = frame.width
        let h: CGFloat = height
        
        topContainer.frame = CGRect(x: x, y: y, width: w, height: h)
        
        w = stateSwitch.getWidth()
        y = 0
        stateSwitch.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    var userMarker: NTMarker!
    
    func showUserAt(location: CLLocation) {
        
        let latitude = Double(location.coordinate.latitude)
        let longitude = Double(location.coordinate.longitude)
        
        let position = projection?.fromWgs84(NTMapPos(x: longitude, y: latitude))
        
        map.setFocus(position, durationSeconds: 1)
        map.setZoom(16, durationSeconds: 1)
        
        if (userMarker == nil) {
            let builder = NTMarkerStyleBuilder()
            
            let bitmap = NTBitmapUtils.createBitmap(from: UIImage(named: "icon_marker_blue.png"))
            builder?.setBitmap(bitmap)
            builder?.setSize(25)
            
            userMarker = NTMarker(pos: position, style: builder?.buildStyle())
            source.add(userMarker)
        }
        
        userMarker.setPos(position)
    }
}
