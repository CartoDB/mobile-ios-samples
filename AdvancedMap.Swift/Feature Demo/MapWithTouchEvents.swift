//
//  MapWithTouchEvents.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 20/11/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class MapWithTouchEvents: NTMapView {
    
    var isTouchInProgress = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchInProgress = true
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchInProgress = false
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchInProgress = false
        super.touchesCancelled(touches, with: event)
    }
}
