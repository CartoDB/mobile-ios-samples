//
//  ClusteringView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 28/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class ClusteringView : MapBaseView {
    
    var baseLayer: NTCartoOnlineVectorTileLayer!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        baseLayer = addBaseLayer()
        
        initialize()
        
        infoContent.setText(headerText: Texts.clusteringInfoHeader, contentText: Texts.basemapInfoContainer)
    }
}
