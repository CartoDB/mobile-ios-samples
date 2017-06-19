//
//  Utils.swift
//  Feature Demo
//
//  Created by Aare Undo on 16/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class Colors {
    
    public static var appleBlue: UIColor = fromRgba(red: 14, green: 122, blue: 254, alpha: 255)
    
    public static var locationRed: UIColor = fromRgba(red: 215, green: 82, blue: 75, alpha: 255)
    
    public static var transparent: UIColor = fromRgba(red: 0, green: 0, blue: 0, alpha: 0)
    
    public static var navy: UIColor = fromRgba(red: 22, green: 41, blue: 69, alpha: 255)
    
    static func fromRgba(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha / 255)
    }
}
