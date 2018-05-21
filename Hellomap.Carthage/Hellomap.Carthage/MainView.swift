//
//  MainView.swift
//  Hellomap.Carthage
//
//  Created by Aare Undo on 21/05/2018.
//  Copyright © 2018 CARTO. All rights reserved.
//

import Foundation
import UIKit

class MainView: UIView {
    
    var map: NTMapView?
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        map = NTMapView()
        addSubview(map!)
        
        let layer = NTCartoOnlineVectorTileLayer(style: NTCartoBaseMapStyle.CARTO_BASEMAP_STYLE_VOYAGER)
        map!.getLayers().add(layer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        map?.frame = bounds
    }
}
