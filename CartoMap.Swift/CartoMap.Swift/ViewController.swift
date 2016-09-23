//
//  ViewController.swift
//  HelloMap.Swift
//
//  Created by Aare Undo on 22/09/16.
//  Copyright © 2016 Aare Undo. All rights reserved.
//

import UIKit

class ViewController: MapBaseController {
    
    var url = "https://documentation.cartodb.com/api/v2/viz/236085de-ea08-11e2-958c-5404a6a683d5/viz.json";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Carto VizJson Map";
        
        mapView?.updateVis(url);
        
        mapView?.setZoom(2, durationSeconds: 2);
    }
}

extension NTMapView {
    func updateVis(url: String) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            self.getLayers().clear();
            
            let loader = NTCartoVisLoader();

            loader.setDefaultVectorLayerMode(true);
            
            let builder = MyCartoVisBuilder(mapView: self);
            
            loader.loadVis(builder, visURL: url);
        }
    }
}

