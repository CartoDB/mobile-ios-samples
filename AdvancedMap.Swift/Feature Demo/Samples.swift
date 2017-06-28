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
        sample.description = "Various samples of different CARTO Base Maps"
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
        sample.imageResource = folder + "icon_sample_city_download.png"
        sample.controller = CityDownloadController()
        
        list.append(sample)
        
        sample = Sample()
        sample.title = "PACKAGE DOWNLOAD"
        sample.description = "Download existing packages for offline use"
        sample.imageResource = folder + "icon_sample_package_download.png"
        sample.controller = PackageDownloadController()
        
        list.append(sample)
        
        sample = Sample()
        sample.title = "VECTOR ELEMENTS"
        sample.description = "Different popups, polygons and a NMLModel"
        sample.imageResource = folder + "icon_sample_vector_objects.png"
        sample.controller = VectorObjectController()
        
        list.append(sample)
        
        sample = Sample()
        sample.title = "ELEMENT CLUSTERING"
        sample.description = "Loads 20000 elements and shows as clusters"
        sample.imageResource = folder + "icon_sample_clustering.png"
        sample.controller = ClusteringController()
        
        list.append(sample)
        
        sample = Sample()
        sample.title = "OBJECT EDITING"
        sample.description = "Places editable objects on the world map"
        sample.imageResource = folder + "icon_sample_object_editing.png"
        sample.controller = VectorObjectEditingController()
        
        list.append(sample)
        sample = Sample()
        sample.title = "GPS LOCATION"
        sample.description = "Locates you and places a marker on the location"
        sample.imageResource = folder + "icon_sample_gps_location.png"
        sample.controller = GPSLocationController()
        
        list.append(sample)
    }
}

class Sample {
    
    var imageResource: String!
    
    var title: String!
    
    var description: String!
    
    var controller: BaseController!
}




