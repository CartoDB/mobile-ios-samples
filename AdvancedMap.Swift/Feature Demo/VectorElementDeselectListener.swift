//
//  VectorElementDeselectEventListener.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 29/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class VectorElementDeselectListener: NTMapEventListener {
    
    var delegate: VectorElementDeselectDelegate?
    
    override func onMapClicked(_ mapClickInfo: NTMapClickInfo!) {
        delegate?.deselect()
    }
}

protocol VectorElementDeselectDelegate {
    func deselect()
}
