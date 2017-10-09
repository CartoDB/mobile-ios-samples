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

    let manager = CLLocationManager()
    
    var mapView: NTMapView!
    var marker: LocationMarker!
    var routing: Routing!
    
    let destinationListener = DestinationClickListener()
    
    init(mapView: NTMapView) {
        super.init()
        
        self.mapView = mapView;
        
        marker = LocationMarker(mapView: mapView)
        routing = Routing(mapView: mapView)
        
        /*
         * For offline use, this service should be NTPackageManagerValhallaRoutingService,
         * using online mode out of convenience, to keep the code cleaner
         */
        routing.service = NTValhallaOnlineRoutingService(apiKey: BaseGeocodingController.API_KEY)
        
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
        
        if (latest.coordinate.latitude != 0 && latest.coordinate.longitude != 0) {
            let start = marker.projection.fromLat(latest.coordinate.latitude, lng: latest.coordinate.longitude)
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
            }
        }
    }

    var latest = CLLocation()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        if (latest.coordinate.latitude == location.coordinate.latitude) {
            if (latest.coordinate.longitude == location.coordinate.longitude) {
                return
            }
        }
        
        latest = location
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        print("Updated Coordinates: " + String(describing: latitude) + ", " + String(describing: longitude))
        
        marker.showAt(location: location)
        
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
        let heading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading)
        
        print("Updated Heading: " + String(describing: heading))
        
        // TODO calculate heading to see whether the user should turn around or is facing the correct direction
    }
}








