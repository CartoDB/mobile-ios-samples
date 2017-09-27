//
//  Samples.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class Samples {
    
    static var list = [Sample]()
    
    static func initialize() {
        
        let folder = ""
        
        var sample = Sample()
        sample.title = "SUBWAY VIS"
        sample.description = "Vis.json of New York subway routes via CARTO.js API"
        sample.imageResource = folder + "image_viz_subway.png"
        sample.controller = TrainVisController()
        
        list.append(sample)
        
        sample = Sample()
        sample.title = "COUNTRIES"
        sample.description = "Vis.json displaying Countries via CARTO.js API"
        sample.imageResource = folder + "image_countries.png"
        sample.controller = CountriesVisController()
        
        list.append(sample)
        
        sample = Sample()
        sample.title = "STORE LOCATION"
        sample.description = "Vis.json of predicted store locations via CARTO.js API"
        sample.imageResource = folder + "image_viz_store.png"
        sample.controller = StoresViewController()
        
        list.append(sample)
    }
}

class Sample {
    
    var imageResource: String!
    
    var title: String!
    
    var description: String!
    
    var controller: UIViewController!
}




