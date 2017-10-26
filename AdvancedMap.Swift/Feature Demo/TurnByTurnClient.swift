//
//  TurnByTurnClient.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 09/10/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import CoreLocation

class TurnByTurnClient: NSObject, CLLocationManagerDelegate, DestinationDelegate {

    var delegate: NextTurnDelegate?
    
    let manager = CLLocationManager()
    
    var mapView: NTMapView!
    var marker: LocationMarker!
    
    /*
     * Ideally it wouldn't be, but Routing is currently a dependeny of this Client.
     * If you want to reuse it in your own application, you need to implement Routing as well (the Routing folder)
     */
    var routing: Routing!
    
    let destinationListener = DestinationClickListener()
    
    init(mapView: NTMapView) {
        super.init()
        
        self.mapView = mapView;
        
        marker = LocationMarker(mapView: mapView)
        marker.isNavigationPointer = true
        
        routing = Routing(mapView: mapView)
        routing.showTurns = false
        
        let green = NTColor(r: 50, g: 200, b: 50, a: 255)
        routing.updateFinishMarker(icon: "icon_navigation_finish.png", size: 50, color: green)
        
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = 1
        
        /*
         * In addition to requesting background location updates, you need to add the following lines to your Info.plist:
         *
         * 1. Privacy - Location When In Use Usage Description
         * 2. Required background modes:
         *    2.1 App registers for location updates
         *
         * In most realistic scenarios, you'd also require:
         * Privacy - Location Always Usage Description
         * and need to call call manager.requestAlwaysAuthorization(), 
         * but we're not doing this here, as it's a sample applocation
         */
        if #available(iOS 9.0, *) {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    // Attach all listeners when your controller appear
    func onResume() {
        manager.delegate = self
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        
        mapView.setMapEventListener(destinationListener)
        destinationListener?.delegate = self
    }
    
    // Detach all listeners when your controller disappears
    func onPause() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
        manager.delegate = nil
        
        mapView.setMapEventListener(nil)
        destinationListener?.delegate = nil
    }

    func destinationSet(position: NTMapPos) {
        routing.setStopMarker(position: position)
        
        if (Int32(latestLocations!.size()) < 1) {
            return
        }
        
        let projection = self.mapView.getOptions().getBaseProjection()
        
        var latest = latestLocations?.get(Int32((latestLocations?.size())! - 1))
        // Calculations are made in the projection's units, translate it back to latitude & longitude
        latest = projection?.toLatLong(latest!.getX(), y: latest!.getY())
        
        let latitude = latest!.getX()
        let longitude = latest!.getY()
        
        if (latitude != 0 && longitude != 0) {
            let start = marker.projection.fromLat(latitude, lng: longitude)
            showRoute(start: start!, stop: position)
        }
    }
    
    func showRoute(start: NTMapPos, stop: NTMapPos) {
        
        DispatchQueue.global().async {
            
            let result = self.routing.getResult(startPos: start, stopPos: stop)
            
            if (result == nil) {
                self.delegate?.routingFailed()
                return
            }
            
            self.delegate?.locationUpdated(result: result!)
            
            let color = NTColor(r: 14, g: 122, b: 254, a: 150)
            DispatchQueue.main.async {
                self.routing.show(result: result!, lineColor: color!, complete: {_ in })
                
                if (result!.getInstructions().size() > 0) {
                    let current = result!.getInstructions().get(0)!
                    let next = result?.getInstructions().get(1)
                    self.delegate?.instructionFound(current: current, next: next)
                }
            }
        }
    }
    
    var latestLocations = NTMapPosVector()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let projection = self.mapView.getOptions().getBaseProjection()
        let new = projection?.fromLat(location.coordinate.latitude, lng: location.coordinate.longitude)

        // Keep the max at five. Take four newest elements, store them in a temporary array
        // and assign latestLocations the value of the newer elements
        if (latestLocations?.size() == 5) {
            let temp = NTMapPosVector()
            for i in 1...4 {
                temp?.add(latestLocations?.get(Int32(i)))
            }
            
            latestLocations = temp
        }
        
        latestLocations?.add(new)
        
        let mercator = routing.matchRoute(points: latestLocations!)
        // Calculations are made in the projection's units, translate it back to latitude & longitude
        let latlon = projection?.toLatLong(mercator!.getX(), y: mercator!.getY())
        
        let latitude = latlon!.getX()
        let longitude = latlon!.getY()
        // Navigation apps usually don't show accuracy, just have it be 0
        let accuracy: Float = 0.0
        
        marker.showAt(latitude: latitude, longitude: longitude, accuracy: accuracy)
        
        let destination = destinationListener?.destination
        
        if (routing.isPointOnRoute(point: mercator!)) {
            // If point is on route, don't render your new route,
            // but still make the calculation internally, so we could update distance and time labels
            DispatchQueue.global().async {
                let result = self.routing.getResult(startPos: mercator!, stopPos: destination!)
                
                if (result != nil) {
                    self.delegate?.locationUpdated(result: result!)
                }
            }
            return
        }
        
        // Zoom & focus is enabled by default, disable after initial location is set
        marker.focus = false

        if (destination != nil) {
            let position = marker.projection.fromLat(latitude, lng: longitude)
            showRoute(start: position!, stop: destination!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        if (newHeading.headingAccuracy < 0) {
            // Ignore if there's no accuracy, no point in processing it
            return
        }
        
        // Use true heading if it is valid.
        let heading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading)
        marker.rotate(rotation: heading)
        
//        let position = marker.navigationPointer.getBounds().getMin()
//        mapView.setRotation(marker.navigationPointer.getRotation(), targetPos: position, durationSeconds: 0)
    }
}

protocol NextTurnDelegate {
    
    func instructionFound(current: NTRoutingInstruction, next: NTRoutingInstruction?)
    
    func routingFailed()
    
    func locationUpdated(result: NTRoutingResult)
}




