//
//  ViewController.swift
//  HelloMap.Swift
//
//  Created by Aare Undo on 22/09/16.
//  Copyright © 2016 Aare Undo. All rights reserved.
//

import UIKit

class ViewController: GLKViewController {
    
    var mapView: NTMapView?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "HelloMap.Swift";
        
        mapView = NTMapView();
        view = mapView;
        
        let baseLayer = NTCartoOnlineVectorTileLayer(style: NTCartoBaseMapStyle.CARTO_BASEMAP_STYLE_DEFAULT);
        mapView?.getLayers().add(baseLayer);
        
        let projection = mapView?.getOptions().getBaseProjection();
        let tallinn = projection?.fromWgs84(NTMapPos(x: 24.646469, y: 59.426939));
        
        mapView?.addMarkerToPostion(projection!, position: tallinn!);
        
        mapView?.setFocusPos(tallinn, durationSeconds: 0);
        mapView?.setZoom(15, durationSeconds: 2);
    }
}

extension NTMapView {
    func addMarkerToPostion(projection: NTProjection, position: NTMapPos) {
        
        let source = NTLocalVectorDataSource(projection: projection);
        
        let layer = NTVectorLayer(dataSource: source);
        
        self.getLayers().add(layer);
        
        let builder = NTMarkerStyleBuilder();
        builder.setSize(15);
        builder.setColor(NTColor(r: 0, g: 255, b: 0, a: 255));
        
        let marker = NTMarker(pos: position, style: builder.buildStyle());
        
        source.add(marker);
    }
}

