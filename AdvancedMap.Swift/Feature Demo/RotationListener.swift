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
    
    var previous: CGFloat?
    
    override func onMapMoved() {
        
        let angle = CGFloat(map.getRotation())
        
        if (previous != angle) {
            delegate?.rotated(angle: angle)
            previous = angle
        }
    }
    
}

protocol RotationDelegate {
    func rotated(angle: CGFloat)
}
