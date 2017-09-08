//
//  ClusterBuilder.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 28/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class ClusterBuilder : NTClusterElementBuilder {
    
    var image: UIImage!
    var elements: [Int: NTMarkerStyle]!

    override func buildClusterElement(_ mapPos: NTMapPos!, elements: NTVectorElementVector!) -> NTVectorElement! {
        
        var style: NTMarkerStyle!
        
        style = findByKey(count: elements.size())
        
        if (elements.size() == 0) {
            style = (elements.get(0) as? NTMarker)?.getStyle()
        }
        
        if (style == nil) {
            
            UIGraphicsBeginImageContext(image.size)
            
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let native = NSString(string: String(elements.size()))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            let attributes: [String: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.black,
                NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 10)!,
                NSParagraphStyleAttributeName: paragraphStyle
            ]
            
            let y: CGFloat = image.size.height / 4
            let x: CGFloat = 0
            let rectangle = CGRect(x: x, y: y, width: image.size.width, height: image.size.height)
            native.draw(in: rectangle, withAttributes: attributes)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            let builder = NTMarkerStyleBuilder()
            builder?.setBitmap(NTBitmapUtils.createBitmap(from: newImage))
            builder?.setSize(30)
            builder?.setPlacementPriority(-(Int32)(elements.size()))
            
            style = builder?.buildStyle()
        }

        return NTMarker(pos: mapPos, style: style)
    }
    
    func findByKey(count: UInt32) -> NTMarkerStyle? {
        
        for (key, _) in elements {
            if (key == Int(count)) {
                return elements[key]
            }
        }
        
        return nil
    }
}
