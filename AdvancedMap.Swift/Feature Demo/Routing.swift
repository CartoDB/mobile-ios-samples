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
    static let OFFLINE_ROUTING_SOURCE = "carto.streets"

    static let MAP_SOURCE = "carto.streets"
    
    var service: NTRoutingService?
    
    var startMarker, stopMarker: NTMarker?
    var instructionUp, instructionLeft, instructionRight: NTMarkerStyle?
    
    var routeDataSource, routeStartStopDataSource: NTLocalVectorDataSource?
    
    var mapView: NTMapView!
    var projection: NTProjection!
    
    var showTurns: Bool = true
    
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
        markerBuilder?.setSize(20)
        
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
    
    func updateFinishMarker(icon: String, size: Float, color: NTColor? = nil) {
        let builder = NTMarkerStyleBuilder()
        builder?.setBitmap(NTBitmapFromString(path: icon))
        builder?.setSize(size)
        builder?.setHideIfOverlapped(false)
        
        if (color != nil) {
            builder?.setColor(color)
        }
        
        builder?.setAnchorPointX(0, anchorPointY: 0)
        
        stopMarker?.setStyle(builder?.buildStyle())
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
            
            if (showTurns) {
                createRoutePoint(position: position!, instruction: instruction!, source: routeDataSource!)
            }
            
            vector?.add(position)
        }
        
        let polygon = NTPolygon(poses: vector, style: NTPolygonStyleBuilder().buildStyle())
        
        let route = Route()
        
        route.bounds = polygon?.getBounds()
        route.length = result.getTotalDistance()
        
        complete(route)
    }
    
    func getMessage(result: NTRoutingResult) -> String {
        
        let distance = round(result.getTotalDistance() / 1000 * 100) / 100
        let message = "Your route is " + String(distance) + "km"
        return message
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
    
    func matchRoute(points: NTMapPosVector) -> NTMapPos? {
        
        if (!(self.service is NTPackageManagerValhallaRoutingService)) {
            return nil
        }
        
//        return points.get(Int32(points.size() - 1))
        
        /*
         * Route matching (NTRouteMatchingRequest & NTRouteMatchingResult)
         * was introduced after the release of v4.1.0.
         * You need a special debug build to match your route.
         * Download the latest version from: https://github.com/CartoDB/mobile-sdk/wiki/Using-dev-build
         * and simply replace (overwrite) CartoMobileSDK.framework file at
         * mobile-ios-samples/AdvancedMap.Swift/Pods/CartoMobileSDK
         *
         * If you do not wish to use the latest dev build,
         * simply comment out these lines and return the final element of the original list.
         */
        let projection = mapView.getOptions().getBaseProjection()
        let accuracy: Float = 10.0
        let request = NTRouteMatchingRequest(projection: projection, points: points, accuracy: accuracy)
        let result: NTRouteMatchingResult = (self.service as! NTPackageManagerValhallaRoutingService).matchRoute(request)
        let points = result.getPoints()
 
        return points?.get(Int32((points?.size())! - 1))
    }
    
    func isPointOnRoute(point: NTMapPos) -> Bool {
        
        let line = getLine()
        
        if (line == nil) {
            return false
        }
        
        let positions = line?.getPoses()
        let count = Int(positions!.size())
        
        for i in 0..<count {
            
            if (i < count - 1) {
                let segmentStart = positions!.get(Int32(i))!
                let segmentEnd = positions!.get(Int32(i + 1))!
                
                let distance = distanceFromLineSegment(point: point, start: segmentStart, end: segmentEnd)
                print("Distance: " + String(describing: distance))

                // TODO: The number it returns should be translated further,
                // due to the earth's curviture, it's smaller near the equator. Normalize it.
                if (distance < 3) {
                    return true
                }
            }
        }
        
        return false
    }
    
    func getLine() -> NTLine? {
        
        let elements = routeDataSource?.getAll()
        let count: Int32 = Int32(elements!.size())
        
        for i in 0..<count {
            let element = elements?.get(i)
            
            if (element is NTLine) {
                return element as? NTLine
            }
        }
        
        return nil
    }
    
    /*
     * Translated from:
     * https://github.com/CartoDB/mobile-sdk/blob/a1a9c175867f3a47bd5eda2062a7d213c42da01a/all/native/utils/GeomUtils.cpp#L30
     */
    func distanceFromLineSegment(point: NTMapPos, start: NTMapPos, end: NTMapPos) -> Double {
        let nearest = calculateNearestPointOnLineSegment(point: point, start: start, end: end)
        return distanceFromPoint(point1: nearest, point2: point)
    }
    
    /*
     * Translated from:
     * https://github.com/CartoDB/mobile-sdk/blob/a1a9c175867f3a47bd5eda2062a7d213c42da01a/all/native/utils/GeomUtils.cpp#L14
     */
    func distanceFromPoint(point1: NTMapPos, point2: NTMapPos) -> Double {
        let diff = getDiff(a: point2, b: point1)
        return sqrt(diff.dotProduct(diff))
    }
    
    /*
     * Translated from:
     * https://github.com/CartoDB/mobile-sdk/blob/a1a9c175867f3a47bd5eda2062a7d213c42da01a/all/native/utils/GeomUtils.cpp#L35
     */
    func calculateNearestPointOnLineSegment(point: NTMapPos, start: NTMapPos, end: NTMapPos) -> NTMapPos {
        
        if (start.isEqual(end)) {
            return start
        }
        
        let diff = getDiff(a: point, b: start)
        let dir = getDiff(a: end, b: start)
        
        let u = clamp(value: diff.dotProduct(dir) / dir.dotProduct(dir), low: 0.0, high: 1.0)
        
        let x = (dir.getX() * u) + start.getX()
        let y = (dir.getY() * u) + start.getY()
        return NTMapPos(x: x, y: y)
    }
    
    /*
     * Translated from:
     * https://github.com/CartoDB/mobile-sdk/blob/3b3b2fa1b91f1395ebd3e166a0609a762c95a9ea/all/native/utils/GeneralUtils.h#L19
     */
    func clamp(value: Double, low: Double, high: Double) -> Double {
        return value < low ? low : (value > high ? high : value)
    }
    
    func getDiff(a: NTMapPos, b: NTMapPos) -> NTMapVec {
        return NTMapVec(x: a.getX() - b.getX(), y: a.getY() - b.getY())
    }
}





