//
//  Routing.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 22/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class Routing {
    
    var service: NTRoutingService?
    
    var startMarker, stopMarker: NTMarker?
    var instructionUp, instructionLeft, instructionRight: NTMarkerStyle?
    
    var routeDataSource, routeStartStopDataSource: NTLocalVectorDataSource?
    
    var mapView: NTMapView!
    var projection: NTProjection!
    
    init(mapView: NTMapView) {
        
        self.mapView = mapView
        projection = mapView.getOptions().getBaseProjection()
        
        let start = NTBitmapFromString(path: "icon_pin_red.png")
        let stop = NTBitmapFromString(path: "icon_pin_red.png")
        
        let up = NTBitmapFromString(path: "icon_pin_red.png")
        let upleft = NTBitmapFromString(path: "icon_pin_red.png")
        let upright = NTBitmapFromString(path: "icon_pin_red.png")
        
        // Define layer and datasource for route line and instructions
        routeDataSource = NTLocalVectorDataSource(projection: projection)
        let routeLayer = NTVectorLayer(dataSource: routeDataSource)
        mapView.getLayers().add(routeLayer)
        
        // Define layer and datasource for route start and stop markers
        routeStartStopDataSource = NTLocalVectorDataSource(projection: projection)
        let vectorLayer = NTVectorLayer(dataSource: routeStartStopDataSource)
        mapView.getLayers().add(vectorLayer)
        
        // Set visible zoom range for the vector layer
        vectorLayer?.setVisibleZoom(NTMapRange(min: 0, max: 22))
        
        let markerBuilder = NTMarkerStyleBuilder()
        markerBuilder?.setBitmap(start)
        markerBuilder?.setHideIfOverlapped(true)
        // Note: When setting the size on Android, you need to account for Resources.DisplayMetrics.Density
        markerBuilder?.setSize(15)
        
        let defaultPosition = NTMapPos(x: 0, y: 0)
        startMarker = NTMarker(pos: defaultPosition, style: markerBuilder?.buildStyle())
        routeStartStopDataSource?.add(startMarker)
        
        markerBuilder?.setBitmap(stop)
        stopMarker = NTMarker(pos: defaultPosition, style: markerBuilder?.buildStyle())
        routeStartStopDataSource?.add(stopMarker)
        
        markerBuilder?.setBitmap(up)
        instructionUp = markerBuilder?.buildStyle()
        
        markerBuilder?.setBitmap(upleft)
        instructionLeft = markerBuilder?.buildStyle()
        
        markerBuilder?.setBitmap(upright)
        instructionRight = markerBuilder?.buildStyle()
    }
    
    func NTBitmapFromString(path: String) -> NTBitmap {
        let image = UIImage(named: path)
        return NTBitmapUtils.createBitmap(from: image)
    }
    
    /*
     * Return bounds on complete so we can start downloading the BBOX
     */
    func show(result: NTRoutingResult, lineColor: NTColor, complete: (_ route: Route) -> Void) {
        routeDataSource?.clear()
        startMarker?.setVisible(true)
        
        let line = createPolyLine(result: result, color: lineColor)
        routeDataSource?.add(line)
        
        let instructions = result.getInstructions()
        
        let vector = NTMapPosVector()
        
        for var i in 0..<Int((instructions?.size())!) {
            
            let instruction = instructions?.get(Int32(i))
            let position = result.getPoints().get(Int32(i))
            
            createRoutePoint(position: position!, instruction: instruction!, source: routeDataSource!)
            vector?.add(position)
        }
        
        let polygon = NTPolygon(poses: vector, style: NTPolygonStyleBuilder().buildStyle())
        
        let route = Route()
        route.bounds = polygon?.getBounds()
        route.length = result.getTotalDistance()
        
        complete(route)
    }
    
    func getMessage(result: NTRoutingResult, start: Double, current: Double) -> String {
        let distance = "Calculated route is " + String(Int(result.getTotalDistance() / 10) * 10) + "km"
        return distance
    }
    
    func getResult(startPos: NTMapPos, stopPos: NTMapPos) -> NTRoutingResult {
        let positions = NTMapPosVector()
        positions?.add(startPos)
        positions?.add(stopPos)
        
        let request = NTRoutingRequest(projection: projection, points: positions)
        
        return (service?.calculateRoute(request))!
    }
    
    func createRoutePoint(position: NTMapPos, instruction: NTRoutingInstruction, source: NTLocalVectorDataSource) {
        
        let action = instruction.getAction()
        
        var style = instructionUp
        
        if (action == .ROUTING_ACTION_TURN_LEFT) {
            style = instructionLeft
        } else if (action == .ROUTING_ACTION_TURN_RIGHT) {
            style = instructionRight
        }
        
        let marker = NTMarker(pos: position, style: style)
        source.add(marker)
    }
    
    func createPolyLine(result: NTRoutingResult, color: NTColor) -> NTLine {
        let builder = NTLineStyleBuilder()
        builder?.setColor(color)
        builder?.setWidth(7)
        
        return NTLine(poses: result.getPoints(), style: builder?.buildStyle())
    }
    
    func setStartMarker(position: NTMapPos) {
        routeDataSource?.clear()
        stopMarker?.setVisible(false)
        startMarker?.setPos(position)
        startMarker?.setVisible(true)
    }
    
    func setStopMarker(position: NTMapPos) {
        stopMarker?.setPos(position)
        stopMarker?.setVisible(true)
    }
}





