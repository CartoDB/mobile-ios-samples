//
//  MapBaseView.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class MapBaseView : UIView {
    
    var map: NTMapView!
    
    override func layoutSubviews() {
        
        if (map != nil) {
            map?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        }
    }
    
    func addBaseLayer() {
        
        if (map == nil) {
            map = NTMapView()
            addSubview(map)
        }
        
        let layer = NTCartoOnlineVectorTileLayer(style: NTCartoBaseMapStyle.CARTO_BASEMAP_STYLE_DEFAULT)
        map.getLayers().add(layer)
    }
}
