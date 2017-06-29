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
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        baseLayer = addBaseLayer()
        
        initialize()
        infoContent.setText(headerText: Texts.gpsLocationInfoHeader, contentText: Texts.basemapInfoContainer)
        
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
    
    func showUserAt(location: CLLocation) {
        
        let latitude = Double(location.coordinate.latitude)
        let longitude = Double(location.coordinate.longitude)
        
        let projection = map.getOptions().getBaseProjection()
        let position = projection?.fromWgs84(NTMapPos(x: longitude, y: latitude))
        
        map.setFocus(position, durationSeconds: 1)
        map.setZoom(15, durationSeconds: 1)
    }
}
