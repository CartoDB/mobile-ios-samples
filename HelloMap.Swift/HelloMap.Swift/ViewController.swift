//
//  ViewController.swift
//  HelloMap.Swift
//
//  Created by Aare Undo on 22/09/16.
//  Copyright © 2016 Aare Undo. All rights reserved.
//

import UIKit
import CartoMobileSDK

class ViewController: GLKViewController {
    
    var mapView: NTMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Miminal sample code follows
        title = "Hello Map"
        preferredFramesPerSecond = 60
        
        // Create NTMapView
        mapView = NTMapView()
        view = mapView
        
        // Set common options. Use EPSG4326 projection so that longitude/latitude can be directly used for coordinates.
        let proj = NTEPSG4326()
        mapView?.getOptions()?.setBaseProjection(proj)
        mapView?.getOptions()?.setRenderProjectionMode(NTRenderProjectionMode.RENDER_PROJECTION_MODE_SPHERICAL)
        mapView?.getOptions()?.setZoomGestures(true)
        
        // Create base map layer
        let baseLayer = NTCartoOnlineVectorTileLayer(style: NTCartoBaseMapStyle.CARTO_BASEMAP_STYLE_VOYAGER)
        mapView?.getLayers().add(baseLayer)

        // Create map position located at Tallinn, Estonia
        let tallinn = NTMapPos(x: 24.646469, y: 59.426939)
        
        // Animate map to Tallinn, Estonia
        mapView?.setFocus(tallinn, durationSeconds: 0)
        mapView?.setRotation(0, durationSeconds: 0)
        mapView?.setZoom(3, durationSeconds: 0)
        mapView?.setZoom(4, durationSeconds: 2)

        // Initialize a local vector data source
        let vectorDataSource = NTLocalVectorDataSource(projection: proj)
        
        // Initialize a vector layer with the created data source
        let vectorLayer = NTVectorLayer(dataSource: vectorDataSource)
        
        // Add the created layer to the map
        mapView?.getLayers().add(vectorLayer)
        
        // Create a marker marker style
        let markerStyleBuilder = NTMarkerStyleBuilder()
        markerStyleBuilder?.setSize(15)
        markerStyleBuilder?.setColor(NTColor(r: 0, g: 255, b: 0, a: 255))
        
        let markerStyle = markerStyleBuilder?.buildStyle()
        
        // Create a marker with the previously defined style and add it to the data source
        let marker = NTMarker(pos: tallinn, style: markerStyle)
        vectorDataSource?.add(marker)

        // Create a map listener so that we will receive click events on a map
        let listener = HelloMapListener(vectorDataSource: vectorDataSource!)
        mapView?.setMapEventListener(listener)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Disconnect listener from the mapView to avoid leaks
        let mapView = view as! NTMapView
        mapView.setMapEventListener(nil)
    }
}

public class HelloMapListener : NTMapEventListener {
    var vectorDataSource: NTLocalVectorDataSource!
    
    convenience init(vectorDataSource: NTLocalVectorDataSource!) {
        self.init()
        self.vectorDataSource = vectorDataSource
    }
    
    override public func onMapClicked(_ mapClickInfo: NTMapClickInfo!) {
        // Create a new marker with random style at the clicked location
        let markerStyleBuilder = NTMarkerStyleBuilder()
        
        let size = Float(arc4random_uniform(20) + 10)
        markerStyleBuilder?.setSize(size)
        
        var colors = [
            NTColor(r: 255, g: 255, b: 255, a: 255),
            NTColor(r: 0, g: 0, b: 255, a: 255),
            NTColor(r: 255, g: 0, b: 0, a: 255),
            NTColor(r: 0, g: 255, b: 0, a: 255),
            NTColor(r: 0, g: 200, b: 0, a: 255),
        ]
        let color = colors[Int(arc4random_uniform(4))]
        markerStyleBuilder?.setColor(color)
        
        let markerStyle = markerStyleBuilder?.buildStyle()
        let marker = NTMarker(pos: mapClickInfo.getClickPos(), style: markerStyle)
        self.vectorDataSource.add(marker)
    }
}
