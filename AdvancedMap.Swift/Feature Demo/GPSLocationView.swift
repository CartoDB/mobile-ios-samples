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

    var projection: NTProjection!
    
    let rotationResetButton = RotationResetButton()
    let scaleBar = ScaleBar()
    
    var locationMarker: LocationMarker!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        initialize()
        baseLayer = addBaseLayer()

        infoContent.setText(headerText: Texts.gpsLocationInfoHeader, contentText: Texts.gpsLocationInfoContainer)
        
        projection = map.getOptions().getBaseProjection()
        locationMarker = LocationMarker(mapView: self.map)
        
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

    func resetMapRotation() {
        map.setRotation(0, durationSeconds: 0.5)
    }

}










