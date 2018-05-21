//
//  AppDelegate.swift
//  Hellomap.Carthage
//
//  Created by Aare Undo on 21/05/2018.
//  Copyright © 2018 CARTO. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let license = "XTUMwQ0ZRQ2YzcjBiV3Q4TWd3TnJaQXpwczlhNmpYWU9Kd0lVY0tIWUo4QjFnMDFyMG9yYm1pbjVIZkFFOHZRPQoKYXBwVG9rZW49ZTNlMDc2ODYtNzkyYS00MzFlLTk3MGEtN2I1MWFmODhkZWJmCmJ1bmRsZUlkZW50aWZpZXI9Y29tLmNhcnRvLmhlbGxvLmNhcnRoYWdlCm9ubGluZUxpY2Vuc2U9MQpwcm9kdWN0cz1zZGstaW9zLTQuKgp3YXRlcm1hcms9Y3VzdG9tCg=="
    
    var window: UIWindow?

    var controller: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        controller = UINavigationController(rootViewController: ViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        NTMapView.registerLicense(license)
        
        return true
    }
}

