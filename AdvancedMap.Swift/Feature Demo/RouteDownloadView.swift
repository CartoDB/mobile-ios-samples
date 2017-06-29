//
//  BboxRoutingView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 22/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class RouteDownloadView : DownloadBaseView {
    
    var mapLayer: NTVectorTileLayer!

    var downloadButton: PopupButton!
    
    var overlaySource: NTLocalVectorDataSource!

    convenience init() {
        
        self.init(frame: CGRect.zero)
        
        mapLayer = addBaseLayer()
        
        initialize()
        initializeDownloadContent()
        
        infoContent.setText(headerText: Texts.routeDownloadInfoHeader, contentText: Texts.routeDownloadInfoContainer)

        downloadButton = PopupButton(imageUrl: "icon_download.png")
        downloadButton.disable()
        addButton(button: downloadButton)
        
        overlaySource = NTLocalVectorDataSource(projection: projection)
        let layer = NTVectorLayer(dataSource: overlaySource);
        map.getLayers().add(layer)
        
        layer?.setVectorElementEventListener(VectorElementIgnoreListener())
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
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













