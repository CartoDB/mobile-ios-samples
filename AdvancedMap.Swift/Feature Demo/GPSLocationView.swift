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
    
    let compass = Compass()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        baseLayer = addBaseLayer()
        
        initialize()
        infoContent.setText(headerText: Texts.gpsLocationInfoHeader, contentText: Texts.gpsLocationInfoContainer)
        
        projection = map.getOptions().getBaseProjection()
        source = NTLocalVectorDataSource(projection: projection)
        let layer = NTVectorLayer(dataSource: source)
        map.getLayers().add(layer)
        
        switchButton = SwitchButton(onImageUrl: "icon_track_location_on.png", offImageUrl: "icon_track_location_off.png")
        addButton(button: switchButton)
        
        addSubview(compass)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 5
        
        let width: CGFloat = 50
        let height = width
        let x = frame.width - (width + padding)
        let y = Device.trueY0() + padding
        
        compass.frame = CGRect(x: x, y: y, width: width, height: height)
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
