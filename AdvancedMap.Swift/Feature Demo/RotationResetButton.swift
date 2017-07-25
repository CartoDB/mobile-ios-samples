//
//  Compass.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 18/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class RotationResetButton: PopupButton {

    let url = "icon_compass.png"
    
    convenience init() {
        self.init(frame: CGRect.zero)
        initialize(imageUrl: url)
    }
    
    var isInitialized = false
    
    override func layoutSubviews() {
        
        // CGAffineTransform calls layoutSubviews and that causes the image to behave in weird ways
        // Simply do not call this again if it's been initialized with a frame
        if (!isInitialized) {
            if (frame.width > 0) {
                isInitialized = true
                super.layoutSubviews()
            }
        }
    }
    
    func rotate(angle: CGFloat) {
        imageView.transform = CGAffineTransform(rotationAngle: angle.degreesToRadians)
    }
    
    var resetDuration: Float = 0
    
    func reset() {
        UIView.animate(withDuration: TimeInterval(resetDuration), animations: {
            self.imageView.transform = CGAffineTransform.identity
            self.imageView.image = UIImage(named: self.url)
        })
    }
    
//    func rotate(bearingRadians: CGFloat, headingRadians: Double) {
//        // Compass orientation calculation partly taken from: https://github.com/zntfdr/Compass
//        let angle = getAngle(bearingRadians: bearingRadians, headingRadians: CGFloat(headingRadians))
//        imageView.transform = CGAffineTransform(rotationAngle: angle)
//    }
    
//     TODO Compass logic: Reimplement when we have a compass
    
//    func getAngle(bearingRadians: CGFloat, headingRadians: CGFloat) -> CGFloat {
//        
//        let originalHeading = bearingRadians - headingRadians
//        var heading = originalHeading
//        let isFaceDown = UIDevice.current.orientation == .faceDown
//        
//        if (isFaceDown) {
//            heading = -originalHeading
//        }
//        
//        let adjAngle: CGFloat = {
//            switch UIApplication.shared.statusBarOrientation {
//            case .landscapeLeft:
//                return 90
//            case .landscapeRight:
//                return -90
//            case .portrait, .unknown:
//                return 0
//            case .portraitUpsideDown:
//                return isFaceDown ? 180 : -180
//            }
//        }()
//        
//        return CGFloat(adjAngle.degreesToRadians + heading)
//    }

}
