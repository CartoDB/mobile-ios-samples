//
//  Route.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 22/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class Route {
    
    var length: Double?
    
    var bounds: NTMapBounds?
    
    func getLengthString() -> String {
        return String(Int((length! / 1000))) + "km"
    }
}
