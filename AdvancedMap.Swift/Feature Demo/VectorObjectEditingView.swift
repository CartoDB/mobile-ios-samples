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
    var trashCan: UIImageView!
    
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

        topBarLabel.textColor = UIColor.white
        topBarLabel.text = "CLICK ON AN ELEMENT TO EDIT IT"
        topBar.addSubview(topBarLabel)
        
        trashCan = UIImageView()
        trashCan.image = UIImage(named: "icon_trashcan.png")
        trashCan.isUserInteractionEnabled = true
        trashCan.isHidden = true
        topBar.addSubview(trashCan)
        
        map.setZoom(0, durationSeconds: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 7
        
        topBarLabel.frame = CGRect(x: padding, y: 0, width: topBar.frame.width  - padding, height: topBar.frame.height)
        
        let height: CGFloat = topBar.frame.height - 2 * padding
        let width: CGFloat = height
        
        trashCan.frame = CGRect(x: topBar.frame.width - (width + padding), y: padding, width: width, height: height)
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

        let polygonBuilder = NTPolygonStyleBuilder()
        polygonBuilder?.setColor(Colors.locationRed.toNTColor())
        
        let polygon = NTPolygon(poses: positions, style: polygonBuilder?.buildStyle())
        
        editSource.add(polygon)
    }
}





