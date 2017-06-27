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
        sample.title = "STYLES"
        sample.description = "Various samples of different carto base maps"
        sample.imageResource = folder + "icon_sample_styles.png"
        sample.controller = StyleChoiceController()
        
        list.append(sample)
        
        sample = Sample()
        sample.title = "ROUTE DOWNLOAD"
        sample.description = "Route download via bounding box for offline use"
        sample.imageResource = folder + "icon_sample_route_download.png"
        sample.controller = RouteDownloadController()
        
        list.append(sample)
        
        sample = Sample()
        sample.title = "CITY DOWNLOAD"
        sample.description = "City download via bounding box for offline use"
        sample.imageResource = folder + "icon_sample_styles.png"
        sample.controller = CityDownloadController()
        
        list.append(sample)
    }
}

class Sample {
    
    var imageResource: String!
    
    var title: String!
    
    var description: String!
    
    var controller: BaseController!
}
