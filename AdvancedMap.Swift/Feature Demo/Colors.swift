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
    
    public static var transparentAppleBlue: UIColor = fromRgba(red: 14, green: 122, blue: 254, alpha: 150)
    
    public static var locationRed: UIColor = fromRgba(red: 215, green: 82, blue: 75, alpha: 255)
    
    public static var transparentLocationRed: UIColor = fromRgba(red: 215, green: 82, blue: 75, alpha: 150)
    
    public static var transparent: UIColor = fromRgba(red: 0, green: 0, blue: 0, alpha: 0)
    
    public static var navy: UIColor = fromRgba(red: 22, green: 41, blue: 69, alpha: 255)
    
    public static var nearWhite: UIColor = fromRgba(red: 245, green: 245, blue: 245, alpha: 255)
    
    public static var transparentNavy: UIColor = fromRgba(red: 22, green: 41, blue: 69, alpha: 150)
    
    public static var transparentGray: UIColor = fromRgba(red: 50, green: 50, blue: 50, alpha: 150)
    
    public static var green: UIColor = fromRgba(red: 115, green: 200, blue: 107, alpha: 255)
    
    public static var purple: UIColor = fromRgba(red: 105, green: 110, blue: 236, alpha: 255)
    
    public static var predictionBlue: UIColor = fromRgba(red: 23, green: 133, blue: 251, alpha: 255)
    
    static func fromRgba(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha / 255)
    }
}

extension UIColor {
    
    func toNTColor() -> NTColor {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        
        getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)
        return NTColor(r: UInt8(fRed * 255.0), g: UInt8(fGreen * 255.0), b: UInt8(fBlue * 255.0), a: UInt8(fAlpha * 255.0))
    }
}

