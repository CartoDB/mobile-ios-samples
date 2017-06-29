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
    var source: NTLocalVectorDataSource!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        baseLayer = addGrayBaseLayer()
        
        initialize()
        
        infoContent.setText(headerText: Texts.clusteringInfoHeader, contentText: Texts.clusteringInfoContainer)
    }
    
    func initializeClusterLayer(builder: ClusterBuilder) {
        source = NTLocalVectorDataSource(projection: map.getOptions().getBaseProjection())
        let layer = NTClusteredVectorLayer(dataSource: source, clusterElementBuilder: builder)
        // Default is 100. A good value depends on data
        layer?.setMinimumClusterDistance(50)
        
        map.getLayers().add(layer)
    }
    
    func addClusters(elements: NTVectorElementVector) {
        source.addAll(elements)
    }
}
