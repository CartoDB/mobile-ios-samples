//
//  Compass.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 18/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class Compass: UIView {
    
    let image = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.white
        
        addSubview(image)
        image.image = UIImage(named: "icon_compass.png")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
    }
    
    var initialized = false
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if (initialized) {
            return
        }
        
        if (frame.width != 0) {
            initialized = true
        }
        layer.cornerRadius = frame.width / 2
        
        let padding: CGFloat = frame.height / 3.5
        
        image.frame = CGRect(x: padding, y: padding, width: frame.width - 2 * padding, height: frame.height - 2 * padding)
        
        addRoundShadow()
    }
    
    func rotate(bearingRadians: CGFloat, headingRadians: Double) {
        // Compass orientation calculation partly taken from: https://github.com/zntfdr/Compass
        let angle = getAngle(bearingRadians: bearingRadians, headingRadians: CGFloat(headingRadians))
        image.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    func getAngle(bearingRadians: CGFloat, headingRadians: CGFloat) -> CGFloat {
        
        let originalHeading = bearingRadians - headingRadians
        var heading = originalHeading
        let isFaceDown = UIDevice.current.orientation == .faceDown
        
        if (isFaceDown) {
            heading = -originalHeading
        }
        
        let adjAngle: CGFloat = {
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:
                return 90
            case .landscapeRight:
                return -90
            case .portrait, .unknown:
                return 0
            case .portraitUpsideDown:
                return isFaceDown ? 180 : -180
            }
        }()
        
        return CGFloat(adjAngle.degreesToRadians + heading)
    }

}
