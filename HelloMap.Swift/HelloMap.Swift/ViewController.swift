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
        
        let marker = mapView?.addMarkerToPostion(projection!, position: tallinn!);
        
        mapView?.setFocusPos(tallinn, durationSeconds: 0);
        mapView?.setZoom(15, durationSeconds: 2);
        
        let listener = HelloMapListener(marker: marker!);
        
        mapView?.setMapEventListener(listener);
    }
}

public class HelloMapListener : NTMapEventListener
{
    var marker: NTMarker?;

    convenience init(marker: NTMarker)
    {
        self.init();
        self.marker = marker;
    }
    
    override public func onMapClicked(mapClickInfo: NTMapClickInfo!) {
        
        let builder = NTMarkerStyleBuilder();
        
        let size = Float(arc4random_uniform(50));
        builder.setSize(size);
        
        var colors = [
            NTColor(r: 255, g: 255, b: 255, a: 255),
            NTColor(r: 0, g: 0, b: 255, a: 255),
            NTColor(r: 255, g: 0, b: 0, a: 255),
            NTColor(r: 0, g: 255, b: 0, a: 255),
            NTColor(r: 0, g: 0, b: 0, a: 255),
        ];
        
        let color = colors[Int(arc4random_uniform(4))];
        builder.setColor(color);
        
        marker?.setStyle(builder.buildStyle());
    }
}

extension NTMapView {
    func addMarkerToPostion(projection: NTProjection, position: NTMapPos) -> NTMarker {
        
        let source = NTLocalVectorDataSource(projection: projection);
        
        let layer = NTVectorLayer(dataSource: source);
        
        self.getLayers().add(layer);
        
        let builder = NTMarkerStyleBuilder();
        builder?.setSize(15);
        builder?.setColor(NTColor(r: 0, g: 255, b: 0, a: 255));
        
        let marker = NTMarker(pos: position, style: builder?.buildStyle());
        
        source?.add(marker);
        
        return marker;
    }
}

