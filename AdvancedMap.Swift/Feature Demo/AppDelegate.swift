//
//  AppDelegate.swift
//  Feature Demo
//
//  Created by Aare Undo on 16/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import UIKit
import HockeySDK
import CartoMobileSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let license = "XTUMwQ0ZRQ3JlQnYreUIzWkZ3Q0Y3V0ZicVVCa0FpTFVwd0lVVFQ2OC93U1pqUWlDRyt1TEIrUisvWUhob0ZNPQoKYXBwVG9rZW49MWVmZDM2ZDQtMjQ0Yi00YjI2LTgyMmUtNWY5NWZjY2ExOTdkCmJ1bmRsZUlkZW50aWZpZXI9amFhay5hZHZhbmNlZC5zd2lmdApvbmxpbmVMaWNlbnNlPTEKcHJvZHVjdHM9c2RrLWlvcy00LioKd2F0ZXJtYXJrPWN1c3RvbQo="
    let identifier = "aea1fd9cdece4a779420c5310fc7b5f5"
    
    var window: UIWindow?

    var controller: UINavigationController?
    
    let attributes: [NSAttributedStringKey : Any]? = [
        NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white,
        NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "HelveticaNeue-Medium", size: 14)!
    ]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        controller = CustomNavigationController(rootViewController: MainViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        
        controller?.navigationBar.barTintColor = Colors.locationRed
        controller?.navigationBar.tintColor = UIColor.white
        controller?.navigationBar.titleTextAttributes = attributes
        
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        NTMapView.registerLicense(license)
        
        Samples.initialize()
        Languages.initialize()
        Cities.initialize()
        MapOptions.initialize()
        
        BITHockeyManager.shared().configure(withIdentifier: identifier)
        BITHockeyManager.shared().start()

        NTLog.setShowError(true)
        NTLog.setShowDebug(true)
        NTLog.setShowWarn(true)
        NTLog.setShowInfo(true)
        
        return true
    }
}

class CustomNavigationController : UINavigationController {
    
    override var shouldAutorotate: Bool {
        return self.visibleViewController!.shouldAutorotate
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.visibleViewController!.supportedInterfaceOrientations
    }
}





