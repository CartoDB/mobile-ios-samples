//
//  ReverseGeocodingView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 06/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class ReverseGeocodingView : MapBaseView {
    
    var baseLayer: NTCartoOnlineVectorTileLayer!
    
    var projection: NTProjection?
    
    var source: NTLocalVectorDataSource!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        baseLayer = addBaseLayer()
        
        initialize()
        infoContent.setText(headerText: Texts.reverseGeocodingInfoHeader, contentText: Texts.reverseGeocodingInfoContainer)
        
        projection = map.getOptions().getBaseProjection()
        
        source = NTLocalVectorDataSource(projection: projection)
        let layer = NTVectorLayer(dataSource: source)
        
        map.getLayers().add(layer)
        
        let position = projection?.fromWgs84(NTMapPos(x: 26.7, y: 58.38))
        map.setFocus(position, durationSeconds: 0)
        map.setZoom(14.5, durationSeconds: 0)
    }
}
