//
//  MapBaseView.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class MapBaseView : UIView {
    
    var map: NTMapView!
    
    var buttons: [PopupButton]!
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override func layoutSubviews() {
        
        if (map != nil) {
            map?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        }
        
        if (self.buttons == nil) {
            return
        }
        
        let count = CGFloat(self.buttons.count)
        
        let bottomPadding: CGFloat = 30
        let buttonWidth: CGFloat = 50
        let innerPadding: CGFloat = 20
        
        let totalArea = buttonWidth * count + (innerPadding * (count - 1))
        
        let w: CGFloat = buttonWidth
        let h: CGFloat = w
        let y: CGFloat = frame.height - (bottomPadding + h)
        var x: CGFloat = frame.width / 2 - totalArea / 2
        
        for button in buttons {
            button.frame = CGRect(x: x, y: y, width: w, height: h)
            
            x += w + innerPadding
        }
    }
    
    func addBaseLayer() -> NTCartoOnlineVectorTileLayer {
        
        if (map == nil) {
            map = NTMapView()
            addSubview(map)
        }
        
        let layer = NTCartoOnlineVectorTileLayer(style: NTCartoBaseMapStyle.CARTO_BASEMAP_STYLE_DEFAULT)
        map.getLayers().add(layer)
        
        return layer!
    }
    
    func addButton(button: PopupButton) {
        
        if (buttons == nil) {
            buttons = [PopupButton]()
        }
        
        buttons.append(button)
        addSubview(button)
    }
    
}





