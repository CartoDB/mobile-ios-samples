//
//  AppDelegate.m
//  HelloMap.Objective-C
//
//  Created by Aare Undo on 01/09/16.
//  Copyright © 2016 Aare Undo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString* License = @"XTUN3Q0ZFTWNwNlBVTGw0SEk1bHZNMmF6MEVqYnN5VkZBaFFUWW5URXRDMStoYlNCNS9EZFl0bTN5M2NyM3c9PQoKYXBwVG9rZW49ZWQ4YmVlYjktNmMwMy00MjcwLWJjMWEtZGFjYjZiMDk4Y2MyCmJ1bmRsZUlkZW50aWZpZXI9Y29tLm51dGl0ZXEuaGVsbG9tYXAub2JqCm9ubGluZUxpY2Vuc2U9MQpwcm9kdWN0cz1zZGstaW9zLTQuKgp3YXRlcm1hcms9Y3VzdG9tCg==";
    
    // The initial step: register your license.
    // This must be done before using MapView
    [NTMapView registerLicense:License];

    return YES;
}

@end
