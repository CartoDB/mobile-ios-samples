//
//  MapMovedListener.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 20/11/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class MapMovedListener: NTMapEventListener {
    
    var delegate: MapMovedDelegate?
    
    override func onMapMoved() {
        delegate?.mapMoved()
    }
}

protocol MapMovedDelegate {
    func mapMoved()
}
