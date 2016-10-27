//
//  AppDelegate.swift
//  HelloMap.Swift
//
//  Created by Aare Undo on 22/09/16.
//  Copyright © 2016 Aare Undo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var License = "XTUN3Q0ZCL1ZER2R2Ukw3WmV0MkROSnYxYy9PRVZkaTJBaFE3OVZsUktoV3E5L1hPbTlvSlYrUGx0am1ETGc9PQoKYXBwVG9rZW49ODU4OWM5NTQtMjc5Zi00NmVkLTljOTQtNjNkOTg4MzMyZWFiCnZhbGlkVW50aWw9MjAxNi0xMC0yMgp3YXRlcm1hcms9Y2FydG9kYgpidW5kbGVJZGVudGlmaWVyPWNhcnRvLkhlbGxvTWFwLVN3aWZ0Cm9ubGluZUxpY2Vuc2U9MQpwcm9kdWN0cz1zZGstaW9zLTQuKgo=";
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        NTMapView.registerLicense(License);
        
        window?.rootViewController = UINavigationController(rootViewController: LauncherListController());
        
        window?.makeKeyAndVisible();
        
        return true
    }

}

