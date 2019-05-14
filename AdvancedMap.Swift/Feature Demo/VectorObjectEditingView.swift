//
//  VectorObjectEditingView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 28/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit
import CartoMobileSDK

class VectorObjectEditingView : MapBaseView {
    
    var baseLayer: NTCartoOnlineVectorTileLayer!
    
    var editLayer: NTEditableVectorLayer!
    
    var editSource: NTLocalVectorDataSource!
    
    var projection: NTProjection!
    
    var trashCan: UIImageView!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        initialize()
        baseLayer = addDarkBaseLayer()
        
        infoContent.setText(headerText: Texts.objectEditingInfoHeader, contentText: Texts.objectEditingInfoContainer)
        
        addBanner(visible: true)
        
        projection = map.getOptions().getBaseProjection()
        
        editSource = NTLocalVectorDataSource(projection: projection)
        editLayer = NTEditableVectorLayer(dataSource: editSource)
        map.getLayers().add(editLayer)
        
        banner.label.text = "CLICK ON AN ELEMENT TO EDIT IT"
        
        trashCan = UIImageView()
        trashCan.image = UIImage(named: "icon_trashcan.png")
        trashCan.isUserInteractionEnabled = true
        trashCan.isHidden = true
        banner.addRightItem(item: trashCan)
        
        map.setZoom(0, durationSeconds: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func addElements() {
        
        editSource.clear()
        
        let color = Colors.green.toNTColor()
        let positions = NTMapPosVector()

        /*
         * Points that form a circle of lines, the contours of the face
         */
        let lineBuilder = NTLineStyleBuilder()
        lineBuilder?.setColor(color)

        let minY: Double = -80
        let maxY: Double = abs(minY)
        
        let minX: Double = -170
        let maxX: Double = abs(minX)
        
        // Counter-clockwise circle starting from south-west/bottom-left
        positions?.add(projection.fromWgs84(NTMapPos(x: -30, y: minY)))
        positions?.add(projection.fromWgs84(NTMapPos(x: -110, y: -75)))
        positions?.add(projection.fromWgs84(NTMapPos(x: minX, y: -40)))
        positions?.add(projection.fromWgs84(NTMapPos(x: minX, y: 40)))
        positions?.add(projection.fromWgs84(NTMapPos(x: -110, y: 75)))
        positions?.add(projection.fromWgs84(NTMapPos(x: -30, y: maxY)))
        positions?.add(projection.fromWgs84(NTMapPos(x: 30, y: maxY)))
        positions?.add(projection.fromWgs84(NTMapPos(x: 110, y: 75)))
        positions?.add(projection.fromWgs84(NTMapPos(x: maxX, y: 40)))
        positions?.add(projection.fromWgs84(NTMapPos(x: maxX, y: -40)))
        positions?.add(projection.fromWgs84(NTMapPos(x: 110, y: -75)))
        positions?.add(projection.fromWgs84(NTMapPos(x: 30, y: minY)))
        positions?.add(projection.fromWgs84(NTMapPos(x: -30, y: minY)))
        
        var line = NTLine(poses: positions, style: lineBuilder?.buildStyle())
        editSource.add(line)
        
        positions?.clear()
        
        /*
         * Points, eyes
         */
        var position = projection.fromWgs84(NTMapPos(x: -50, y: 50))
        let pointBuilder = NTPointStyleBuilder()
        pointBuilder?.setColor(color)
        
        var point = NTPoint(pos: position, style: pointBuilder?.buildStyle())
        editSource.add(point)
        
        position = projection.fromWgs84(NTMapPos(x: 50, y: 50))
        point = NTPoint(pos: position, style: pointBuilder?.buildStyle())
        editSource.add(point)
        
        /*
         * Polygon, nose
         */
        positions?.add(projection.fromWgs84(NTMapPos(x: 0, y: 20)))
        positions?.add(projection.fromWgs84(NTMapPos(x: -35, y: -30)))
        positions?.add(projection.fromWgs84(NTMapPos(x: 0, y: -30)))
        
        let polygonBuilder = NTPolygonStyleBuilder()
        polygonBuilder?.setColor(color)
        
        let polygon = NTPolygon(poses: positions, style: polygonBuilder?.buildStyle())
        
        editSource.add(polygon)
        
        positions?.clear()
        
        /*
         * Lines, mouth
         */
        positions?.add(projection.fromWgs84(NTMapPos(x: 0, y: -65)))
        positions?.add(projection.fromWgs84(NTMapPos(x: 60, y: -65)))
        positions?.add(projection.fromWgs84(NTMapPos(x: 90, y: -55)))
        positions?.add(projection.fromWgs84(NTMapPos(x: 100, y: -45)))
        positions?.add(projection.fromWgs84(NTMapPos(x: 110, y: -20)))
        
        line = NTLine(poses: positions, style: lineBuilder?.buildStyle())
        editSource.add(line)
    }
}





