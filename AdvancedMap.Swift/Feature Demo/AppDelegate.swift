//
//  AppDelegate.swift
//  Feature Demo
//
//  Created by Aare Undo on 16/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let license = "XTUN3Q0ZHdnljVlVQSGV0SUFKSHpMQ2E2d2lqSHBkOWVBaFFzWHQ3aHBKWno1RGJHZ0NlaFFUem5pc3hLanc9PQoKYXBwVG9rZW49ZTJjMTBmMGItYzFkNy00MDkwLWEwNTQtNTcxMDQ5NDk2NjViCmJ1bmRsZUlkZW50aWZpZXI9Y29tLmNhcnRvLmFkdmFuY2VkLnN3aWZ0Cm9ubGluZUxpY2Vuc2U9MQpwcm9kdWN0cz1zZGstaW9zLTQuKgp3YXRlcm1hcms9Y3VzdG9tCg=="
    
    var window: UIWindow?

    var controller: UINavigationController?
    
    let attributes: [String: AnyObject]? = [
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 14)!
    ]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        controller = UINavigationController(rootViewController: MainViewController())
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
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

