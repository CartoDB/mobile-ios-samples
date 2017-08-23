//
//  ScaleBar.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 23/08/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

/*
 * Basic ScaleBar implementation.
 *
 * Should be used together with NTMapEventListener (RotationListener in our case)
 * The calculation should be done on a different thread
 */
class ScaleBar: UIView {
    
    /*
     * MapView must be initialized for the calculation to work
     */
    var map: NTMapView!
    
    var projection: NTProjection { return map.getOptions().getBaseProjection() }
    
    let bottomBorder = UIView()
    let label = UILabel()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        label.textColor = UIColor.gray
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textAlignment = .right
        addSubview(label)
        
        bottomBorder.backgroundColor = UIColor.lightGray
        addSubview(bottomBorder)
    }
    
    override func layoutSubviews() {
        
        label.frame = bounds
        
        let w: CGFloat = frame.width
        let h: CGFloat = 1
        let x: CGFloat = 0
        let y: CGFloat = frame.height - h;
        bottomBorder.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func update() {
        
        if (map == nil) {
            fatalError("MapView must be initialized")
        }
        
        if (map.getZoom() < 5) {
            // Calculating scale is pointless if we're that far up
            return
        }
        
        // Take 2 map positions, left and right in middle of mapview
        let sp1 = NTScreenPos(x: 0, y: Float(map.frame.height / 2))
        let sp2 = NTScreenPos(x: Float(map.frame.width), y: Float(map.frame.height / 2))
        
        let pos1Wgs = projection.toWgs84(map.screen(toMap: sp1))!
        let pos2Wgs = projection.toWgs84(map.screen(toMap: sp2))!
        
        // Calculate distance with haversine formula
        let latDistance = (pos1Wgs.getY() - pos2Wgs.getY()).toRadians
        let lonDistance = (pos1Wgs.getX() - pos2Wgs.getX()).toRadians
        
        let AVERAGE_RADIUS_OF_EARTH = 6378137.0;
        
        let a =
            sin(latDistance / 2.0) * sin(latDistance / 2.0) +
                cos(pos1Wgs.getY().toRadians) * cos(pos2Wgs.getY().toRadians) *
                sin(lonDistance / 2.0) * sin(lonDistance / 2.0)
        
        let c = Double(2.0 * atan2(sqrt(a), sqrt(1.0 - a)))
        
        // Total distance shown by the MapView
        let distanceMeters = AVERAGE_RADIUS_OF_EARTH * c
        
        let ratio = frame.width / map!.frame.width
        var scale = CGFloat(distanceMeters) * ratio
        
        // TODO calculation incorrect, gives almost exactly 0.5x the actual value
        scale = 2 * scale
        
        DispatchQueue.main.async {
            if (scale > 1000) {
                self.label.text = String(describing: Int(scale / 1000)) + "km"
            } else {
                self.label.text = String(describing: Int(scale)) + "m"
            }
        }
    }
}




