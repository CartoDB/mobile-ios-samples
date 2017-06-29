//
//  VectorObjectEditingView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 28/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class VectorObjectEditingView : MapBaseView {
    
    var baseLayer: NTCartoOnlineVectorTileLayer!
    
    var editLayer: NTEditableVectorLayer!
    
    var editSource: NTLocalVectorDataSource!
    
    var projection: NTProjection!
    
    var topBarLabel: UILabel!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        baseLayer = addDarkBaseLayer()
        
        initialize()
        infoContent.setText(headerText: Texts.objectEditingInfoHeader, contentText: Texts.basemapInfoContainer)
        
        addTopBar()
        
        projection = map.getOptions().getBaseProjection()
        
        editSource = NTLocalVectorDataSource(projection: projection)
        editLayer = NTEditableVectorLayer(dataSource: editSource)
        map.getLayers().add(editLayer)
        
        topBarLabel = UILabel()
        topBarLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        topBarLabel.textAlignment = .center
        topBarLabel.textColor = UIColor.white
        topBarLabel.text = "CLICK ON AN ELEMENT TO EDIT IT"
        topBar.addSubview(topBarLabel)
        
        map.setZoom(0, durationSeconds: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topBarLabel.frame = topBar.bounds
    }
    
    func addElements() {
        
        editSource.clear()
        
        let positions = NTMapPosVector()
        // min-x, min-y
        positions?.add(projection.fromWgs84(NTMapPos(x: 0, y: 0)))
        // max-x, min-y
        positions?.add(projection.fromWgs84(NTMapPos(x: 100, y: 0)))
        // max-x, max-y
        positions?.add(projection.fromWgs84(NTMapPos(x: 100, y: 100)))
        // min-x, max-y
        positions?.add(projection.fromWgs84(NTMapPos(x: 0, y: 100)))
        
//        positions?.add(NTMapPos(x: -4000000, y: -4000000))
//        positions?.add(NTMapPos(x: 4000000, y: -4000000))
//        positions?.add(NTMapPos(x: 0, y: 7000000))
        
        let builder = NTPolygonStyleBuilder()
        builder?.setColor(Colors.locationRed.toNTColor())
        
        let polygon = NTPolygon(poses: positions, style: builder?.buildStyle())
        
        editSource.add(polygon)
    }
}
