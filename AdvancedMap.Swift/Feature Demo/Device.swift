//
//  Device.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 20/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class Device {
    
    static func isLandscape() -> Bool
    {
        return UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
    }
    
    static func isTablet() -> Bool
    {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var navigationbarHeight: CGFloat!
    
    static func statusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
}
