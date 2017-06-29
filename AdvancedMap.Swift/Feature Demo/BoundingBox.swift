//
//  BoundingBox.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 26/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class BoundingBox : NSObject {
    
    static let identifier = "bbox("
    
    var name: String!
    
    var minLat: Double!
    
    var minLon: Double!
    
    var maxLat: Double!
    
    var maxLon: Double!
    
    func getCenter() -> NTMapPos {
        return NTMapPos(x: (maxLon + minLon) / 2, y: (maxLat + minLat) / 2)
    }
    
    var bounds: NTMapBounds!
    
    override init() {
        
    }
    
    init(minLon: Double, maxLon: Double, minLat: Double, maxLat: Double) {
        self.minLon = minLon
        self.maxLon = maxLon
        self.minLat = minLat
        self.maxLat = maxLat
    }
    
    func toString() -> String {
        
        // TODO Format correctly; also... why the hell does the top line produce outrageous numbers!?
//        return String(format: "bbox(%ld, %ld, %ld, %ld)", minLon, minLat, maxLon, maxLat)
        return "bbox(" + String(minLon) + "," + String(minLat) + "," + String(maxLon) + "," + String(maxLat) + ")"
    }
    
    static func fromMapBounds(projection: NTProjection, bounds: NTMapBounds, extraMeters: Double) -> BoundingBox {
        
        // TODO meters to mercator projection units
        let min = NTMapPos(x: bounds.getMin().getX(), y: bounds.getMin().getY())
        let max = NTMapPos(x: bounds.getMax().getX(), y: bounds.getMax().getY())
        
        let minWgs = projection.toWgs84(min)
        let maxWgs = projection.toWgs84(max)
        
        let box = BoundingBox()
        
        box.minLat = minWgs?.getY()
        box.minLon = minWgs?.getX()
        box.maxLat = maxWgs?.getY()
        box.maxLon = maxWgs?.getX()
        
        box.bounds = NTMapBounds(min: min, max: max)
        
        return box
    }
    
    static func fromString(projection: NTProjection, route: String) -> BoundingBox {
        
        let box = BoundingBox()
        
        let split = route.components(separatedBy: ",")
        // This will crash the application if the input isn't exactly correct,
        // I only trust myself because I construct the BoundingBox with the ToString() method here
        box.minLon = Double(split[0].replacingOccurrences(of: "bbox(", with: ""))
        box.minLat = Double(split[1])
        box.maxLon = Double(split[2])
        box.maxLat = Double(split[3].replacingOccurrences(of: ")", with: ""))
        
        let min = projection.fromLat(box.minLat, lng: box.minLon)
        let max = projection.fromLat(box.maxLat, lng: box.maxLon)
        box.bounds = NTMapBounds(min: min, max: max)
        
        return box
    }
}
