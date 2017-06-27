//
//  BboxRoutingView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 22/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class RouteDownloadView : MapBaseView {
    
    var mapLayer: NTVectorTileLayer!
    
    var onlineSwitch: StateSwitch!
    
    var downloadButton: PopupButton!
    
    var progressLabel: ProgressLabel!
    
    var overlaySource: NTLocalVectorDataSource!
    
    var projection: NTProjection!
    
    convenience init() {
        
        self.init(frame: CGRect.zero)
        
        mapLayer = addBaseLayer()
        
        initialize()

        infoContent.setText(headerText: Texts.bboxRoutingInfoHeader, contentText: Texts.basemapInfoContainer)
        
        onlineSwitch = StateSwitch()
        addSubview(onlineSwitch)
        
        downloadButton = PopupButton(imageUrl: "icon_download.png")
        downloadButton.disable()
        addButton(button: downloadButton)
        
        progressLabel = ProgressLabel()
        addSubview(progressLabel)
        
        projection = map.getOptions().getBaseProjection()
        
        overlaySource = NTLocalVectorDataSource(projection: projection)
        let layer = NTVectorLayer(dataSource: overlaySource);
        map.getLayers().add(layer)
        
        layer?.setVectorElementEventListener(VectorElementIgnoreListener())
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let padding: CGFloat = 5
        
        var w: CGFloat = onlineSwitch.getWidth()
        var h: CGFloat = 40
        var x: CGFloat = frame.width - (w + padding)
        var y: CGFloat = Device.trueY0() + padding
        
        onlineSwitch.frame = CGRect(x: x, y: y, width: w, height: h)
        
        w = frame.width
        h = bottomLabelHeight
        x = 0
        y = frame.height - h
        
        progressLabel.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func addPolygonTo(bounds: NTMapBounds) {
        
        let builder = NTPolygonStyleBuilder()
        builder?.setColor(NTColor(r: 100, g: 100, b: 230, a: 60))
        
        let positions = NTMapPosVector();
        
        // Positions added in clockwise order from south-west
        positions?.add(NTMapPos(x: bounds.getMin().getX(), y: bounds.getMin().getY()));
        positions?.add(NTMapPos(x: bounds.getMax().getX(), y: bounds.getMin().getY()));
        positions?.add(NTMapPos(x: bounds.getMax().getX(), y: bounds.getMax().getY()));
        positions?.add(NTMapPos(x: bounds.getMin().getX(), y: bounds.getMax().getY()));
        
        let polygon = NTPolygon(poses: positions, style: builder?.buildStyle())
        
        overlaySource.add(polygon);
    }
    
    func addPolygonsTo(packageList: [NTPackageInfo]) {
        
        for item in packageList {
            
            let id = item.getPackageId()
            
            if (id?.contains(BoundingBox.identifier))! {
                let bounds = BoundingBox.fromString(projection: self.projection, route: id!).bounds
                addPolygonTo(bounds: bounds!)
            }
        }
    }
}

class VectorElementIgnoreListener : NTVectorElementEventListener {
    
    override func onVectorElementClicked(_ clickInfo: NTVectorElementClickInfo!) -> Bool {
        return false
    }
}













