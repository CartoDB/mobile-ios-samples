//
//  ReverseGeocodingEventListener.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 06/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class ReverseGeocodingEventListener: NTMapEventListener {
    
    var delegate: ReverseGeocodingEventDelegate?
    
    var projection: NTProjection!
    
    var service: NTPackageManagerReverseGeocodingService!
    
    override func onMapClicked(_ mapClickInfo: NTMapClickInfo!) {
        
        let location = mapClickInfo.getClickPos()
        let request = NTReverseGeocodingRequest(projection: projection, location: location)
        
        let meters: Float = 125.0
        request?.setSearchRadius(meters)
        
        let results = service.calculateAddresses(request)
        
        // Scan the results list. If we found relatively close point-based match,
        // use this instead of the first result.
        // In case of POIs within buildings, this allows us to hightlight POI instead of the building
        
        var result: NTGeocodingResult?
        
        let count = (results?.size())!
        
        if (count > 0) {
            result = results?.get(0)
        }
        
        for var i in 0..<count {
            let other = results?.get(Int32(i))
            
            // 0.8f means 125 * (1.0 - 0.9) = 12.5 meters (rank is relative distance)
            if ((other?.getRank())! > Float(0.9)) {
                let name = other?.getAddress().getName()
                // Points of interest usually have names, others just have addresses
                if (name != nil && name != "") {
                    result = other
                    break
                }
            }
            
            i += 1
        }
        
        delegate?.foundResult(result: result)
    }
}

protocol ReverseGeocodingEventDelegate {
    func foundResult(result: NTGeocodingResult!)
}
