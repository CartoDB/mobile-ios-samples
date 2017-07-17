//
//  Routing.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 22/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class Routing {
    
    static let ROUTING_TAG = "routing:"
    static let ROUTING_SOURCE = "valhalla.osm"
    static let MAP_SOURCE = "nutiteq.osm"
    static let TRANSPORT_MODE = ".car"
    
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
        
        let up = NTBitmapFromString(path: "direction_up.png")
        let upleft = NTBitmapFromString(path: "direction_upthenleft.png")
        let upright = NTBitmapFromString(path: "direction_upthenright")
        
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
        markerBuilder?.setHideIfOverlapped(false)
        // Note: When setting the size on Android, you need to account for Resources.DisplayMetrics.Density
        markerBuilder?.setSize(15)
        
        let defaultPosition = NTMapPos(x: 0, y: 0)
        startMarker = NTMarker(pos: defaultPosition, style: markerBuilder?.buildStyle())
        startMarker?.setVisible(false)
        
        routeStartStopDataSource?.add(startMarker)
        
        markerBuilder?.setBitmap(stop)
        stopMarker = NTMarker(pos: defaultPosition, style: markerBuilder?.buildStyle())
        stopMarker?.setVisible(false)
        
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
        
        let count = Int((instructions?.size())!)
        for i in stride(from: 0, to: count, by: 1) {

            let instruction = instructions?.get(Int32(i))
            
            let index = Int32((instruction?.getPointIndex())!)
            let position = result.getPoints().get(index)
            
            
            createRoutePoint(position: position!, instruction: instruction!, source: routeDataSource!)
            vector?.add(position)
        }
        
        let polygon = NTPolygon(poses: vector, style: NTPolygonStyleBuilder().buildStyle())
        
        let route = Route()
        
        route.bounds = polygon?.getBounds()
        route.length = result.getTotalDistance()
        
        complete(route)
    }
    
    func getMessage(result: NTRoutingResult) -> String {
        let distance = "Calculated route is " + String(Int(result.getTotalDistance() / 10000) * 10) + "km"
        return distance
    }
    
    func getResult(startPos: NTMapPos, stopPos: NTMapPos) -> NTRoutingResult? {
        let positions = NTMapPosVector()
        positions?.add(startPos)
        positions?.add(stopPos)
        
        let request = NTRoutingRequest(projection: projection, points: positions)
        
        var result: NTRoutingResult?
        
        /*
         * Swift handles exceptions differently from Objective-C.
         * Native exceptions cannot be caught with Swift's do-catch method.
         *
         * Created custom ExceptionHandler.h and imported it in the bridging header in order to catch them natively
         * cf https://stackoverflow.com/questions/34956002/how-to-properly-handle-nsfilehandle-exceptions-in-swift-2-0/35003095#35003095
         */
        let exception = tryBlock {
            result = self.service?.calculateRoute(request)
        }

        if (exception != nil) {
            return nil
        }
        
        return result
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





