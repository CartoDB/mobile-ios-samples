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

    var instructionDelegate: NextTurnDelegate?
    
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
        routing = Routing(mapView: mapView)
        
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
                // Routing failed, try again
                return
            }
            
            let color = NTColor(r: 14, g: 122, b: 254, a: 150)
            DispatchQueue.main.async {
                self.routing.show(result: result!, lineColor: color!, complete: {_ in })
                
                if (result!.getInstructions().size() > 0) {
                    var instruction = result!.getInstructions().get(0)!
                    
                    if (instruction.getAction() == NTRoutingAction.ROUTING_ACTION_START_AT_END_OF_STREET && result!.getInstructions().size() > 1) {
                        // We can ignore this instruction, as it's a pseudo-one, just telling you to start
                       instruction = result!.getInstructions().get(1)!
                    }
                    
                    self.instructionDelegate?.instructionFound(instruction: instruction)
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
        
        var position = latestLocations?.get(Int32((latestLocations?.size())! - 1))
        // Calculations are made in the projection's units, translate it back to latitude & longitude
        position = projection?.toLatLong(position!.getX(), y: position!.getY())
        
        let latitude = position!.getX()
        let longitude = position!.getY()
        // Navigation apps usually don't show accuracy, just have it be 0
        let accuracy: Float = 0.0
        
        marker.showAt(latitude: latitude, longitude: longitude, accuracy: accuracy)
        
        // Zoom & focus is enabled by default, disable after initial location is set
        marker.focus = false
        
        let destination = destinationListener?.destination
        
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
        // TODO calculate heading to see whether the user should turn around or is facing the correct direction
//        let heading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading)
    }
}

protocol NextTurnDelegate {
    func instructionFound(instruction: NTRoutingInstruction)
}




