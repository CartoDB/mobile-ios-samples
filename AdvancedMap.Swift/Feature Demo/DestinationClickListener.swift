//
//  DestinationClickListener.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 09/10/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class DestinationClickListener : NTMapEventListener {
    
    var delegate: DestinationDelegate?
    
    var destination: NTMapPos!
    
    override func onMapClicked(_ mapClickInfo: NTMapClickInfo!) {
        
        if (mapClickInfo.getClickType() != NTClickType.CLICK_TYPE_LONG) {
            // Only listen to long clicks
            return
        }
        
        let position = mapClickInfo.getClickPos()
        destination = position
        
        delegate?.destinationSet(position: destination)
    }
}

protocol DestinationDelegate {
    
    func destinationSet(position: NTMapPos)
}
