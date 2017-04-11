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
    
    NSString* License = @"XTUMwQ0ZRQ3VqQkgxQ3RSVjlLNlNSUmZFOXR0VDlWdzc3Z0lVWEZMQ1hIVis5Njc5Y1lYWHE1TXJOYXY2TEQ0PQoKYXBwVG9rZW49NzkwODczNmUtMmFmNS00YTg4LWI1NGItNGVmNWI1MzRlNjA5CmJ1bmRsZUlkZW50aWZpZXI9Y29tLmNhcnRvLmhlbGxvbWFwLm9iagpvbmxpbmVMaWNlbnNlPTEKcHJvZHVjdHM9c2RrLWlvcy00LioKd2F0ZXJtYXJrPWN1c3RvbQo=";
    
    // The initial step: register your license.
    // This must be done before using MapView
    [NTMapView registerLicense:License];

    return YES;
}

@end
