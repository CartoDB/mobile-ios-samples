//
//  RouteMapEventListener.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 26/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

/*
 * This MapListener waits for two clicks on map - first to set routing start point, and then
 * second to mark end point and start routing service.
 */
class RouteMapEventListener : NTMapEventListener {
    
    
    var delegate: RouteMapEventDelegate?
    
    var startPosition, stopPosition: NTMapPos!
    
    override func onMapClicked(_ mapClickInfo: NTMapClickInfo!) {
        
        if (mapClickInfo.getClickType() != NTClickType.CLICK_TYPE_LONG) {
            // Only listen to long clicks
            return
        }
        
        let position = mapClickInfo.getClickPos()
        
        let event = RouteMapEvent()
        
        if (startPosition == nil) {
            startPosition = position
            
            event.clickPosition = position
            
            delegate?.startClicked(event: event)
        } else {
            stopPosition = position
            
            event.clickPosition = position
            event.startPosition = startPosition
            event.stopPosition = stopPosition
            
            delegate?.stopClicked(event: event)
            
            startPosition = nil
            stopPosition = nil
        }
    }
}

protocol RouteMapEventDelegate {
    
    func startClicked(event: RouteMapEvent)
    
    func stopClicked(event: RouteMapEvent)
}

class RouteMapEvent : NSObject {
    
    var clickPosition: NTMapPos!
    
    var startPosition: NTMapPos!
    
    var stopPosition: NTMapPos!
}
