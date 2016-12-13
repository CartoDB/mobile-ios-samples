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
    
    var License = "XTUN3Q0ZGZm5HTUtROUUyQ3AwNXRVOTR6b2U5VUVsYXhBaFJOaHhLS2NldEM4MGVRcUhPK0I0cXB6b2Y2OGc9PQoKYXBwVG9rZW49MzNkNzY2NTAtNjZjNy00YjJlLTkyMWYtMDczMzBmZWNmMDNkCmJ1bmRsZUlkZW50aWZpZXI9Y29tLmNhcnRvLmhlbGxvbWFwCm9ubGluZUxpY2Vuc2U9MQpwcm9kdWN0cz1zZGstaW9zLTQuKgp3YXRlcm1hcms9Y3VzdG9tCg==";
    
    func application(_: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        NTLog.setShowInfo(true);
        NTMapView.registerLicense(License);
        
        window?.rootViewController = UINavigationController(rootViewController: ViewController());
        
        window?.makeKeyAndVisible();
        
        return true
    }

}

