//
//  StyleChoiceController.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import  UIKit

class BboxRoutingController : BaseController {
    
    let ROUTING_TAG = "routing:"
    let ROUTING_SOURCE = "valhalla.osm"
    let MAP_SOURCE = "nutiteq.osm"
    let TRANSPORT_MODE = ".car"
    
    var routing: Routing!
    
    var contentView: BboxRoutingView!
    
    var boundingBox: BoundingBox!
    
    var mapPackageListener: MapPackageListener!
    var routingPackageListener : RoutingPackageListener!
    
    var routingManager: NTCartoPackageManager!
    var mapManager: NTCartoPackageManager!
    
//    var service: NTPackageManagerValhallaRoutingService!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        contentView = BboxRoutingView()
        
        view = contentView
        
        routing = Routing(mapView: contentView.map)
        
        mapPackageListener = MapPackageListener()
        routingPackageListener = RoutingPackageListener()
        
        var folder = createDirectory(name: "mappackages")
        mapManager = NTCartoPackageManager(source: MAP_SOURCE, dataFolder: folder)
        
        folder = createDirectory(name: "routingpackages")
        routingManager = NTCartoPackageManager(source: ROUTING_TAG + ROUTING_SOURCE, dataFolder: folder)
        
//        service = NTPackageManagerValhallaRoutingService(packageManager: routingManager)   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
    }
    
    func createDirectory(name: String) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return path + "/" + name
    }
}
