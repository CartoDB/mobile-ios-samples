//
//  VectorElementSelectEventListener.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 29/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class VectorElementSelectListener : NTVectorElementEventListener {
    
    var delegate: VectorElementSelectDelegate?
    
    override func onVectorElementClicked(_ clickInfo: NTVectorElementClickInfo!) -> Bool {
        delegate?.selected(element: clickInfo.getVectorElement())
        return true
    }
}

protocol VectorElementSelectDelegate {
    
    func selected(element: NTVectorElement)
}
