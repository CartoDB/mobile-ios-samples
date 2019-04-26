//
//  Device.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 20/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

@objc class Device : NSObject {
    
    @objc static func isLandscape() -> Bool {
        return UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
    }
    
    @objc static func isTablet() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    @objc static func navigationbarHeight() -> CGFloat {
        return ((UIApplication.shared.delegate as! AppDelegate).navigationController?.navigationBar.frame.height)!
    }
    
    @objc static func statusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    @objc static func trueY0() -> CGFloat {
        return navigationbarHeight() + statusBarHeight()
    }
}
