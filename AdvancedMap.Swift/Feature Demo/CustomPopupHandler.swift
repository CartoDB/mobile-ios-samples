//
//  CustomPopupHandler.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 14/09/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit
import CartoMobileSDK

class CustomPopupHandler : NTCustomPopupHandler {
    
    static let SCREEN_PADDING: CGFloat = 10
    static let POPUP_PADDING: CGFloat = 10
    static let FONT_SIZE: Float = 15
    static let STROKE_WIDTH: CGFloat = 2
    static let TRIANGLE_SIZE: CGFloat = 10
    
    var text = ""
    
    override func onDrawPopup(_ popupDrawInfo: NTPopupDrawInfo!) -> NTBitmap! {
        
        let style = popupDrawInfo.getPopup().getStyle()
        
        var dpToPX = popupDrawInfo.getDPToPX()
        var pxToDP = 1 / dpToPX
        
        if (style?.isScaleWithDPI())! {
            dpToPX = 1
        } else {
            pxToDP = 1
        }
        
        let screenWidth = CGFloat(popupDrawInfo.getScreenBounds().getWidth() * pxToDP)
        let screenHeight = CGFloat(popupDrawInfo.getScreenBounds().getHeight() * pxToDP)
        
        let textFontSize = CustomPopupHandler.FONT_SIZE * dpToPX
        let triangleWidth = CustomPopupHandler.TRIANGLE_SIZE * CGFloat(dpToPX)
        let triangleHeight = CustomPopupHandler.TRIANGLE_SIZE * CGFloat(dpToPX)
        let strokeWidth = CustomPopupHandler.STROKE_WIDTH * CGFloat(dpToPX)
        let screenPadding = CustomPopupHandler.SCREEN_PADDING * CGFloat(dpToPX)
        
        let textFont = UIFont(name: "HelveticaNeue-Light", size: CGFloat(textFontSize))
        let backgroundColor = UIColor.white
        let strokeColor = UIColor.black
        
        // Calculate maximum popup size, adjust with dpi
        let maxWidth = CGFloat.minimum(screenWidth, screenHeight)
        
        // Calculate maximum text and description width
        let halfStrokeWidth = strokeWidth * 0.5
        let maxTextWidth = maxWidth - (screenPadding * 2 + strokeWidth)
        
        // Measure text and description sizes
        let attributes: [NSAttributedStringKey : Any]? = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): textFont!]
        
        let maxSize = CGSize(width: Int(maxTextWidth), height: Int.max)
        let textSize = self.text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        
        let popupWidth = textSize.width + CGFloat(2 * CustomPopupHandler.POPUP_PADDING + strokeWidth + triangleWidth)
        let popupHeight = textSize.height + CGFloat(2 * CustomPopupHandler.POPUP_PADDING + strokeWidth)
        
        UIGraphicsBeginImageContext(CGSize(width: popupWidth, height: popupHeight))
        let context = UIGraphicsGetCurrentContext()
        
        
        // Prepare background path
        let backgroundStrokeRect = CGRect(x: triangleWidth, y: halfStrokeWidth, width: (popupWidth - strokeWidth - triangleWidth), height: popupHeight - strokeWidth)
        let backgroundPath = UIBezierPath(roundedRect: backgroundStrokeRect, cornerRadius: 1)
        
        // Prepare triangle path
        let path = CGMutablePath()
        path.move(to: CGPoint(x: triangleWidth, y: 0))
        path.addLine(to: CGPoint(x: halfStrokeWidth, y: triangleHeight * 0.5))
        path.addLine(to: CGPoint(x: triangleWidth, y: triangleHeight))
        path.closeSubpath()
        
        // Calculate anchor point and triangle position
        let triangleOffsetX = CGFloat(0)
        let triangleOffsetY = (popupHeight - triangleHeight) / 2
        
        // Stroke background
        strokeColor.setStroke()
        backgroundPath.stroke()
        
        // Stroke triangle
        context?.saveGState()
        context?.translateBy(x: triangleOffsetX, y: triangleOffsetY)
        context?.setLineWidth(strokeWidth)
        context?.addPath(path)
        context?.setStrokeColor(strokeColor.cgColor)
        context?.strokePath()
        context?.restoreGState()
        
        // Fill background
        backgroundColor.setFill()
        backgroundPath.fill()
        
        // Fill triangle
        context?.saveGState()
        context?.translateBy(x: triangleOffsetX, y: triangleOffsetY)
        context?.addPath(path)
        context?.setFillColor(backgroundColor.cgColor)
        context?.fillPath()
        context?.restoreGState()
        
        // Draw text
        context?.setFillColor(UIColor.black.cgColor)
        
        let x = halfStrokeWidth + CustomPopupHandler.POPUP_PADDING + triangleWidth
        let y = CustomPopupHandler.POPUP_PADDING
        let textRext = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
        
        NSString(string: self.text).draw(in: textRext, withAttributes: attributes)
        
        // Extract image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return NTBitmapUtils.createBitmap(from: image)
    }
    
    override func onPopupClicked(_ popupClickInfo: NTPopupClickInfo!) -> Bool {
        return true
    }
}











