//
//  MapOptions.swift
//  AdvancedMap.Swift
//
//  Created by carto on 15/05/2019.
//  Copyright © 2019 CARTO. All rights reserved.
//

import Foundation

class MapOptions {
    
    static var list = [MapOption]()
    
    static func initialize() {
        
        var mapOption = MapOption()
        mapOption.name = "Globe view"
        mapOption.tag = "globe"
        mapOption.value = false
        
        list.append(mapOption)
        
        mapOption = MapOption()
        mapOption.name = "3D buildings"
        mapOption.tag = "buildings3d"
        mapOption.value = false
        
        list.append(mapOption)

        mapOption = MapOption()
        mapOption.name = "3D texts"
        mapOption.tag = "texts3d"
        mapOption.value = true
        
        list.append(mapOption)
    }
}

class MapOption : NSObject {
    
    var name: String!
    
    var tag: String!
    
    var value: Bool!
}
