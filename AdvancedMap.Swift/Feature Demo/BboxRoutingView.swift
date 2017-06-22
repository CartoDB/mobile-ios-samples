//
//  BboxRoutingView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 22/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class BboxRoutingView : MapBaseView {
    
    var mapLayer: NTVectorTileLayer!
    
    convenience init() {
        
        self.init(frame: CGRect.zero)
        
        mapLayer = addBaseLayer()
        
        initialize()

        infoContent.setText(headerText: Texts.bboxRoutingInfoHeader, contentText: Texts.basemapInfoContainer)
    }
}
