//
//  MapBaseController.swift
//  CartoMap.Swift
//
//  Created by Aare Undo on 23/09/16.
//  Copyright © 2016 Aare Undo. All rights reserved.
//

import Foundation

import UIKit

class MapBaseController: GLKViewController {
    
    var mapView: NTMapView?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize MapView and set it as the view
        mapView = NTMapView();
        view = mapView;
        
        // Add default base layer
        let baseLayer = NTCartoOnlineVectorTileLayer(style: NTCartoBaseMapStyle.CARTO_BASEMAP_STYLE_DEFAULT);
        mapView?.getLayers().add(baseLayer);
        
        // GLKViewController-specific parameters for smoother animations
        self.resumeOnDidBecomeActive = true;
        self.preferredFramesPerSecond = 60;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        // GLKViewController-specific, do on-demand rendering instead of constant redrawing
        // This is VERY IMPORTANT as it stops battery drain when nothing changes on the screen!
        paused = true;
    }
}