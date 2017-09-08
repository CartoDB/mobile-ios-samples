//
//  VectorObjectMapListener.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 28/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class VectorObjectMapListener : NTMapEventListener {
    
    var objectListener: VectorObjectClickListener!
    
    override func onMapClicked(_ mapClickInfo: NTMapClickInfo!) {
        objectListener.reset()
    }
}
