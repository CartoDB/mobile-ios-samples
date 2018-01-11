//
//  AppDelegate.swift
//  Feature Demo
//
//  Created by Aare Undo on 16/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import UIKit
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let license = "XTUN3Q0ZHdnljVlVQSGV0SUFKSHpMQ2E2d2lqSHBkOWVBaFFzWHQ3aHBKWno1RGJHZ0NlaFFUem5pc3hLanc9PQoKYXBwVG9rZW49ZTJjMTBmMGItYzFkNy00MDkwLWEwNTQtNTcxMDQ5NDk2NjViCmJ1bmRsZUlkZW50aWZpZXI9Y29tLmNhcnRvLmFkdmFuY2VkLnN3aWZ0Cm9ubGluZUxpY2Vuc2U9MQpwcm9kdWN0cz1zZGstaW9zLTQuKgp3YXRlcm1hcms9Y3VzdG9tCg=="
    let identifier = "aea1fd9cdece4a779420c5310fc7b5f5"
    
    var window: UIWindow?

    var controller: UINavigationController?
    
    let attributes: [String: AnyObject]? = [
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 14)!
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





