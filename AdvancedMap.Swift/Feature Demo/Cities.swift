//
//  Cities.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class Cities {
    
    static var list = [City]()
    
    static func initialize() {
        
        var city = City()
        var box = BoundingBox()
        
        city.name = "Berlin"
        
        box.minLon = 13.2285
        box.maxLon = 13.5046
        box.minLat = 52.4698
        box.maxLat = 52.57477
        
        city.boundingBox = box
        list.append(city)
        
        city = City()
        box = BoundingBox()
        
        city.name = "New York"
        
//        box.minLon = -73.4768
//        box.maxLon = -74.1205
        box.minLon = -74.1205
        box.maxLon = -73.4768
        box.minLat = 40.4621
        box.maxLat = 41.0043
        
        city.boundingBox = box
        list.append(city)
        
        city = City()
        box = BoundingBox()
        
        city.name = "Madrid"
        
        box.minLon = -3.7427
        box.maxLon = -3.6432
        box.minLat = 40.3825
        box.maxLat = 40.4904
        
        city.boundingBox = box
        list.append(city)
        
        city = City()
        box = BoundingBox()
        
        city.name = "Paris"
        
        box.minLon = 2.1814
        box.maxLon = 2.4356
        box.minLat = 48.8089
        box.maxLat = 48.9176
        
        city.boundingBox = box
        list.append(city)
        
        city = City()
        box = BoundingBox()
        
        city.name = "San Francisco"
        
        box.minLon = -122.3368
        box.maxLon = -122.56210
        box.minLat = 37.6022
        box.maxLat = 37.6022
        
        city.boundingBox = box
        list.append(city)
        
        city = City()
        box = BoundingBox()
        
        city.name = "London"
        
        box.minLon = -0.5036
        box.maxLon = 0.3276
        box.minLat = 51.2871
        box.maxLat = 51.6939
        
        city.boundingBox = box
        list.append(city)
        
        city = City()
        box = BoundingBox()
        
        city.name = "Mexico City"
        
        box.minLon = -99.329453
        box.maxLon = -98.937378
        box.minLat = 19.251515
        box.maxLat = 19.608956
        
        city.boundingBox = box
        list.append(city)
        
        city = City()
        box = BoundingBox()
        
        city.name = "Barcelona"
        
        box.minLon = 2.098732
        box.maxLon = 2.249451
        box.minLat = 41.345629
        box.maxLat = 41.454049
        
        city.boundingBox = box
        list.append(city)
        
        city = City()
        box = BoundingBox()
        
        city.name = "Tartu"
        
        box.minLon = 26.6548
        box.maxLon = 26.7901
        box.minLat = 58.3404
        box.maxLat = 58.3964
        
        city.boundingBox = box
        list.append(city)
        
        city = City()
        box = BoundingBox()
        
        city.name = "New Delhi"
        
        box.minLon = 77.1477
        box.maxLon = 77.2757
        box.minLat = 28.5361
        box.maxLat = 28.6368
        
        city.boundingBox = box
        list.append(city)
    }
}

class City : NSObject {
    
    var name: String!
    
    var boundingBox: BoundingBox!
}













