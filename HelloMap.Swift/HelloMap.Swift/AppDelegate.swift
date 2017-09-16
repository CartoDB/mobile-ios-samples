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
    
    var License = "XTUN3Q0ZGVElyN0E0QzlKbXRSZncycUxEMUlGTHFpbXVBaFF4WXp5MHVYUlRjSHNZWXo1VklxZDlBWU9GS3c9PQoKYXBwVG9rZW49MGM0ZjAwNTYtNjUxYS00ODJkLTgzZDAtOGE1YzA0YjQwYzdhCmJ1bmRsZUlkZW50aWZpZXI9Y29tLmNhcnRvLmhlbGxvbWFwLnN3aWZ0Cm9ubGluZUxpY2Vuc2U9MQpwcm9kdWN0cz1zZGstaW9zLTQuKgp3YXRlcm1hcms9Y3VzdG9tCg==";
    
    func application(_: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        NTLog.setShowInfo(true);
        NTMapView.registerLicense(License);
        
        window?.rootViewController = UINavigationController(rootViewController: ViewController());
        
        window?.makeKeyAndVisible();
        
        return true
    }

}

