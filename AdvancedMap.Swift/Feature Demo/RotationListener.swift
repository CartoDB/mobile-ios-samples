//
//  MapClickListener.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 24/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class RotationListener: NTMapEventListener {
    
    var delegate: RotationDelegate?
    var map: NTMapView!
    
    var previousAngle: CGFloat?
    var previousZoom: CGFloat?
    
    override func onMapMoved() {
        
        let angle = CGFloat(map.getRotation())
        let zoom = CGFloat(map.getZoom())
        
        if (previousAngle != angle) {
            delegate?.rotated(angle: angle)
            previousAngle = angle
        } else if (previousZoom != zoom) {
            delegate?.zoomed(zoom: zoom)
            previousZoom = zoom
        }
    }
}

protocol RotationDelegate {
    
    func rotated(angle: CGFloat)
    
    func zoomed(zoom: CGFloat)
}
