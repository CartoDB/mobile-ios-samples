//
//  RouteSearchView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 17/08/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class RouteSearchView: MapBaseView {
    
    var baseLayer: NTVectorTileLayer!
    var baseSource: NTTileDataSource!
    
    var overlaySource: NTLocalVectorDataSource!
    var overlayLayer: NTVectorLayer!
    
    var popupSource: NTLocalVectorDataSource!
    var popupLayer: NTVectorLayer!
    
    var searchService: NTVectorTileSearchService!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        initialize()
        addBanner(visible: false)
        
        baseLayer = addGrayBaseLayer()
        baseSource = baseLayer.getDataSource()
        
        let projection = map.getOptions().getBaseProjection()
        
        overlaySource = NTLocalVectorDataSource(projection: projection)
        overlayLayer = NTVectorLayer(dataSource: overlaySource)
        map.getLayers().add(overlayLayer)
        
        popupSource = NTLocalVectorDataSource(projection: projection)
        popupLayer = NTVectorLayer(dataSource: popupSource)
        map.getLayers().add(popupLayer)
        
        searchService = NTVectorTileSearchService(dataSource: baseSource, tileDecoder: baseLayer.getTileDecoder())
        
        infoContent.setText(headerText: Texts.routeSearchInfoHeader, contentText: Texts.routeSearchInfoContainer)
        
        let washingtonDC = projection?.fromWgs84(NTMapPos(x: -77.0369, y: 38.9072))
        map.setFocus(washingtonDC, durationSeconds: 0.0)
        map.setZoom(13.0, durationSeconds: 0.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func clearPOIs() {
        overlaySource.clear()
    }
    
    func addPOI(feature: NTVectorTileFeature) {
        
        let builder = NTPointStyleBuilder()
        builder?.setSize(20.0)
        builder?.setColor(NTColor(r: 230, g: 100, b: 100, a: 200))
        
        let position = (feature.getGeometry() as! NTPointGeometry).getPos()
        let point = NTPoint(pos: position, style: builder?.buildStyle())
        
        point?.setMetaData(VectorObjectClickListener.CLICK_TITLE, element: NTVariant(string: "Properties"))
        point?.setMetaData(VectorObjectClickListener.CLICK_DESCRIPTION, element: NTVariant(string: feature.getProperties().description))
        
        overlaySource.add(point)
    }
}






