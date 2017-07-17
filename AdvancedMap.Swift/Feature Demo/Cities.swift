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
        
        var city = City(name: "Berlin")
        var box = BoundingBox(minLon: 13.2285, maxLon: 13.5046, minLat: 52.4698, maxLat: 52.57477)
        city.boundingBox = box
        list.append(city)
        
        city = City(name: "New York")
        box = BoundingBox(minLon: -74.1205, maxLon: -73.4768, minLat: 40.4621, maxLat: 41.0043)
        city.boundingBox = box
        list.append(city)
        
        city = City(name: "Madrid")
        box = BoundingBox(minLon: -3.7427, maxLon: -3.6432, minLat: 40.3825, maxLat: 40.4904)
        city.boundingBox = box
        list.append(city)
        
        city = City(name: "Paris")
        box = BoundingBox(minLon: 2.1814, maxLon: 2.4356, minLat: 48.8089, maxLat: 48.9176)
        city.boundingBox = box
        list.append(city)
        
        city = City(name: "San Francisco")
        box = BoundingBox(minLon: -122.5483, maxLon: -122.3382, minLat: 37.6642, maxLat: 37.8173)
        city.boundingBox = box
        list.append(city)
        
        city = City(name: "London")
        box = BoundingBox(minLon: -0.5036, maxLon: 0.3276, minLat: 51.2871, maxLat: 51.6939)
        city.boundingBox = box
        list.append(city)
        
        city = City(name: "Mexico City")
        box = BoundingBox(minLon: -99.329453, maxLon: -98.937378, minLat: 19.251515, maxLat: 19.608956)
        city.boundingBox = box
        list.append(city)
        
        city = City(name: "Barcelona")
        box = BoundingBox(minLon: 2.098732, maxLon: 2.249451, minLat: 41.345629, maxLat: 41.454049)
        city.boundingBox = box
        list.append(city)
        
        city = City(name: "Tartu")
        box = BoundingBox(minLon: 26.6548, maxLon: 26.7901, minLat: 58.3404, maxLat: 58.3964)
        city.boundingBox = box
        list.append(city)
        
        city = City(name: "New Delhi")
        box = BoundingBox(minLon: 77.1477, maxLon: 77.2757, minLat: 28.5361, maxLat: 28.6368)
        
        city.boundingBox = box
        list.append(city)
    }
}

class City : NSObject {
    
    var name: String!
    
    var boundingBox: BoundingBox!
    
    override init() {
        
    }
    
    init(name: String) {
        self.name = name
    }
}













