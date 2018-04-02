//
//  VectorElementView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 28/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class VectorObjectView : MapBaseView {
    
    var baseLayer: NTCartoOnlineVectorTileLayer!
    var source: NTLocalVectorDataSource!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        initialize()
        baseLayer = addBaseLayer()
        
        infoContent.setText(headerText: Texts.vectorElementsInfoHeader, contentText: Texts.vectorElementsInfoContainer)
        
        let projection = map.getOptions().getBaseProjection()
        // Initialize an local vector data source
        let source = NTLocalVectorDataSource(projection: projection);
        
        // Initialize a vector layer with the previous data source
        let vectorLayer = NTVectorLayer(dataSource: source);
        map.getLayers().add(vectorLayer)
        
        // Set vector object listener to receive vector object click event
        let listener = VectorObjectClickListener()
        listener?.source = source
        vectorLayer?.setVectorElementEventListener(listener)
        
        // Set map listener to receive map click event
        let mapListener = VectorObjectMapListener()
        mapListener?.objectListener = listener
        map.setMapEventListener(mapListener)
        
        let longitude = -77.0369
        let latitude = 38.9072
        let washingtonDC = projection?.fromWgs84(NTMapPos(x: longitude, y: latitude))
        
        // Set specific focus, zoom, tilt and rotation for an optimal initial view
        map.setFocus(washingtonDC, durationSeconds: 0)
        map.setZoom(14.5, durationSeconds: 0)
        map.setTilt(20, durationSeconds: 0)
        map.setRotation(-30, durationSeconds: 0)
        
        /*
         * Milktruck NML Model
         */
        let data = NTAssetUtils.loadAsset("milktruck.nml")
        let model = NTNMLModel(pos: washingtonDC, sourceModelData: data)
        model?.setScale(20)
        model?.setMetaData(VectorObjectClickListener.CLICK_TITLE, element: NTVariant(string: "Milktruck"))
        model?.setMetaData(VectorObjectClickListener.CLICK_DESCRIPTION, element: NTVariant(string: "This is an nml file loaded from bundled assets"))
        source?.add(model)
        
        /*
         * 3D Polygon
         */
        let builder3D = NTPolygon3DStyleBuilder()
        builder3D?.setColor(Colors.transparentNavy.toNTColor())
        
        let positions = NTMapPosVector()
        positions?.add(projection?.fromWgs84(NTMapPos(x: longitude + 0.001, y: latitude - 0.001)))
        positions?.add(projection?.fromWgs84(NTMapPos(x: longitude + 0.0015, y: latitude - 0.001)))
        positions?.add(projection?.fromWgs84(NTMapPos(x: longitude + 0.002, y: latitude - 0.001)))
        positions?.add(projection?.fromWgs84(NTMapPos(x: longitude + 0.002, y: latitude - 0.002)))
        positions?.add(projection?.fromWgs84(NTMapPos(x: longitude + 0.0015, y: latitude - 0.001)))
        positions?.add(projection?.fromWgs84(NTMapPos(x: longitude + 0.001, y: latitude - 0.002)))
        
        let holes = NTMapPosVectorVector()
        
        let polygon = NTPolygon3D(poses: positions, holes: holes, style: builder3D?.buildStyle(), height: 150)
        polygon?.setMetaData(VectorObjectClickListener.CLICK_TITLE, element: NTVariant(string: "3D Polygon"))
        polygon?.setMetaData(VectorObjectClickListener.CLICK_DESCRIPTION, element: NTVariant(string: "This a gray 3D polygon"))
        source?.add(polygon)
        
        /*
         * Balloon Popup
         */
        let balloonBuilder = NTBalloonPopupStyleBuilder()
        
        balloonBuilder?.setLeftMargins(NTBalloonPopupMargins(left: 6, top: 6, right: 6, bottom: 6))
        balloonBuilder?.setLeftImage(Utils.pathToBitmap(path: "info.png"))
        
        balloonBuilder?.setRightMargins(NTBalloonPopupMargins(left: 2, top: 6, right: 12, bottom: 6))
        balloonBuilder?.setRightImage(Utils.pathToBitmap(path: "arrow.png"))
        
        balloonBuilder?.setPlacementPriority(1)
        balloonBuilder?.setTitleFontSize(15)
        balloonBuilder?.setDescriptionFontSize(12)
        
        var position = projection?.fromWgs84(NTMapPos(x: longitude + 0.003, y: latitude + 0.003))
        let balloonPopup = NTBalloonPopup(pos: position, style: balloonBuilder?.buildStyle(), title: "Balloon popup", desc: "Look at me, whee!")
        balloonPopup?.setMetaData(VectorObjectClickListener.CLICK_TITLE, element: NTVariant(string: "Did you just click me?"))
        balloonPopup?.setMetaData(VectorObjectClickListener.CLICK_DESCRIPTION, element: NTVariant(string: "You'd better not try that again"))
        source?.add(balloonPopup)
        
        positions?.clear()
        
        /*
         * Line
         */
        let lineBuilder = NTLineStyleBuilder()
        positions?.add(projection?.fromWgs84(NTMapPos(x: longitude - 0.0015, y: latitude - 0.001)))
        positions?.add(projection?.fromWgs84(NTMapPos(x: longitude - 0.001, y: latitude - 0.002)))
        lineBuilder?.setColor(Colors.green.toNTColor())
        let line = NTLine(poses: positions, style: lineBuilder?.buildStyle())
        line?.setMetaData(VectorObjectClickListener.CLICK_TITLE, element: NTVariant(string: "Hi! They call me Line!"))
        line?.setMetaData(VectorObjectClickListener.CLICK_DESCRIPTION, element: NTVariant(string: "I'm just a little fatso line between the point and the car. I dislike the car"))
        source?.add(line)
        
        /*
         * Marker
         */
        let markerBuilder = NTMarkerStyleBuilder()
        markerBuilder?.setColor(Colors.appleBlue.toNTColor())
        markerBuilder?.setSize(15)
        markerBuilder?.setBitmap(Utils.pathToBitmap(path: "icon_pin_red.png"))
        position = projection?.fromWgs84(NTMapPos(x: longitude - 0.005, y: latitude - 0.005))
        let marker = NTMarker(pos: position, style: markerBuilder?.buildStyle())
        marker?.setMetaData(VectorObjectClickListener.CLICK_TITLE, element: NTVariant(string: "Hi!"))
        marker?.setMetaData(VectorObjectClickListener.CLICK_DESCRIPTION, element: NTVariant(string: "I'm a dark blue marker, my name is Mark"))
        source?.add(marker)
        
        /*
         * Point
         */
        let pointBuilder = NTPointStyleBuilder()
        pointBuilder?.setColor(Colors.locationRed.toNTColor())
        position = projection?.fromWgs84(NTMapPos(x: longitude - 0.003, y: latitude - 0.003))
        let point = NTPoint(pos: position, style: pointBuilder?.buildStyle())
        point?.setMetaData(VectorObjectClickListener.CLICK_TITLE, element: NTVariant(string: "Hi!"))
        point?.setMetaData(VectorObjectClickListener.CLICK_DESCRIPTION, element: NTVariant(string: "I'm just a red dot lying on the ground"))
        source?.add(point)
        
        /*
         * Custom Popup
         */
        let bitmap = NTBitmapUtils.createBitmap(from: UIImage(named: "marker.png"))
        
        let customMarkerBuilder = NTMarkerStyleBuilder()
        customMarkerBuilder?.setBitmap(bitmap)
        customMarkerBuilder?.setSize(30)
        
        position = projection?.fromWgs84(NTMapPos(x: longitude - 0.01, y: latitude))
        
        let customMarker = NTMarker(pos: position, style: customMarkerBuilder?.buildStyle())
        customMarker?.setMetaData(VectorObjectClickListener.CLICK_TITLE, element: NTVariant(string: "Howdy!"))
        customMarker?.setMetaData(VectorObjectClickListener.CLICK_DESCRIPTION, element: NTVariant(string: "I'm just a regular ol' marker with a custom bitmap"))
        source?.add(customMarker)
        
        let handler = CustomPopupHandler()
        handler?.text = "Custom popup\n attached to a marker"
        
        let popupBuilder = NTPopupStyleBuilder()
        popupBuilder?.setAttachAnchorPointX(0.5, attachAnchorPointY: 0)
        
        let customPopup = NTCustomPopup(baseBillboard: customMarker, style: popupBuilder?.buildStyle(), popupHandler: handler)
        customPopup?.setAnchorPointX(-1.0, anchorPointY: 0.0)
        customPopup?.setMetaData(VectorObjectClickListener.CLICK_TITLE, element: NTVariant(string: "Howdy!"))
        customPopup?.setMetaData(VectorObjectClickListener.CLICK_DESCRIPTION, element: NTVariant(string: "And I'm an entirely custom popup. I'm awesome!"))
        source?.add(customPopup)
        
        /*
         * Text with border and line break
         */
        position = projection?.fromWgs84(NTMapPos(x: longitude - 0.01, y: latitude + 0.01))
        
        let textBuilder = NTTextStyleBuilder()
        textBuilder?.setBreakLines(true)
        textBuilder?.setBorderColor(Colors.green.toNTColor())
        textBuilder?.setTextMargins(NTTextMargins(left: 5, top: 5, right: 5, bottom: 5))
        textBuilder?.setColor(UIColor.black.toNTColor())
        textBuilder?.setFontSize(12.0)
        textBuilder?.setBackgroundColor(UIColor.white.toNTColor())
        textBuilder?.setBorderWidth(2.0)
        textBuilder?.setHideIfOverlapped(false)
        
        let text = "Look at me\nI'm broken in three lines\nand have a green border";
        let textElement = NTText(pos: position, style: textBuilder?.buildStyle(), text: text)
        source?.add(textElement)
        
        
    }
    
    override func addRecognizers() {
        super.addRecognizers()
    }
    
    override func removeRecognizers() {
        super.removeRecognizers()
    }
}












