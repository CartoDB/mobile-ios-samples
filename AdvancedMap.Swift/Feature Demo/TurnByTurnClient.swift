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
    
    init(mapView: NTMapView) {
        super.init()
        
        self.mapView = mapView;
        
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = 1
        
        /*
         * In addition to requesting background location updates, you need to add the following lines to your Info.plist:
         *
         * 1. Privacy - Location When In Use Usage Description
         * 3. Required background modes:
         *    3.1 App registers for location updates
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        print("Coordinates: " + String(describing: latitude) + ", " + String(describing: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("Updated heading: " + String(describing: newHeading.magneticHeading))
    }
}
