//
//  TurnByTurnClient.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 09/10/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import CoreLocation

class TurnByTurnClient: NSObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    var mapView: NTMapView!
    var marker: LocationMarker!
    
    init(mapView: NTMapView) {
        super.init()
        
        self.mapView = mapView;
        
        marker = LocationMarker(mapView: mapView)
        
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
    
    func onResume() {
        manager.delegate = self
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    func onPause() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
        manager.delegate = nil
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
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        if (newHeading.headingAccuracy < 0) {
            // Ignore if there's no accuracy, no point in processing it
            return
        }
        
        // Use true heading if it is valid.
        let heading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading)
        
        print("Updated Heading: " + String(describing: heading))
    }
}








