//
//  MyCartoVisBuilder.swift
//  CartoMap.Swift
//
//  Created by Aare Undo on 23/09/16.
//  Copyright © 2016 Aare Undo. All rights reserved.
//

import Foundation

class MyCartoVisBuilder : NTCartoVisBuilder {
    
    var mapView: NTMapView?;
    
    convenience init(mapView: NTMapView) {
        self.init();
        self.mapView = mapView;
    }
    
    override func addLayer(layer: NTLayer!, attributes: NTVariant!) {
        self.mapView!.getLayers().add(layer);
    }
}