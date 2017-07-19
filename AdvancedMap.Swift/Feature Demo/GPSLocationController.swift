//
//  GPSLocationController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 28/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class GPSLocationController : BaseController, CLLocationManagerDelegate {
    
    var contentView: GPSLocationView!
    
    var manager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = GPSLocationView()
        view = contentView
        
        manager = CLLocationManager()
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = 1
        
        /*
         * In addition to requesting background location updates, you need to add the following lines to your Info.plist:
         *
         * 1. Privacy - Location When In Use Usage Description
         * 2. Privacy - Location Always Usage Description
         * 3. Required background modes:
         *    3.1 App registers for location updates
         */
        if #available(iOS 9.0, *) {
            manager.requestAlwaysAuthorization()
        }
        
        if #available(iOS 9.0, *) {
            manager.allowsBackgroundLocationUpdates = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        
        manager.delegate = self
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
        manager.delegate = nil
    }
    
    var latestLocation: CLLocation!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Latest location saved as class variable to get bearing to adjust compass
        latestLocation = locations[0]
        
        // Not "online", but reusing the online switch to achieve location tracking functionality
        if (contentView.switchButton.isOnline()) {
            contentView.showUserAt(location: latestLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // cf. LocationExtensions.swift to see how these calculations are made
        let bearingRadians = latestLocation.bearingToLocationRadian(UserDefaults.standard.currentLocation)
        let headingRadians = newHeading.trueHeading.degreesToRadians
        
        contentView.compass.rotate(bearingRadians: bearingRadians, headingRadians: headingRadians)
    }

}









