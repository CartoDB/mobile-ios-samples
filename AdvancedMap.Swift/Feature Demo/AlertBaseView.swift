//
//  AlertBaseView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 04/08/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class AlertBaseView: UIView {
    
    func isVisible() -> Bool {
        return self.alpha == 1
    }
    
    func hide() {
        if (isVisible()) {
            animateAlpha(alpha: 0)
        }
    }
    
    func show() {
        if (!isVisible()) {
            animateAlpha(alpha: 1)
        }
    }
    
    func animateAlpha(alpha: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = alpha
        })
    }
}
