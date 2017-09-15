//
//  SlideInMenuView.swift
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 15/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

import Foundation
import UIKit

class SlideInMenuView: UIView {
    
    let banner = Banner()
    let popup = SlideInPopup()
    
    let buttons = [PopupButton]()
    
    let bannerHeight: CGFloat = 45
    let bottomLabelHeight: CGFloat = 40
    let smallPadding: CGFloat = 5
    
    init() {
        super.init(frame: CGRect.zero)
        
        addSubview(banner)
        
        addSubview(popup)
        sendSubview(toBack: popup)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        popup.frame = bounds
        
        let count = CGFloat(self.buttons.count)
        
        let buttonWidth: CGFloat = 60
        let innerPadding: CGFloat = 25
            
        let totalArea = buttonWidth * count + (innerPadding * (count - 1))
        
        let w: CGFloat = buttonWidth
        let h: CGFloat = w
        let y: CGFloat = frame.height - (bottomLabelHeight + h + smallPadding)
        var x: CGFloat = frame.width / 2 - totalArea / 2
        
        for button in buttons {
            button.frame = CGRect(x: x, y: y, width: w, height: h)
            
            x += w + innerPadding
        }
    
        banner.frame = CGRect(x: 0, y: Device.trueY0(), width: frame.width, height: bannerHeight)
    }
}
