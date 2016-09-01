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
    
    NSString* License = @"XTUMwQ0ZRQ2NSQjBQK1lWQURTMmxZdEpxNGtEMmFJNEcrUUlVS3RpdVFveFBFVDJjcmhGWkdNbjd4WVVpbUFFPQoKcHJvZHVjdHM9c2RrLWlvcy00LioKYnVuZGxlSWRlbnRpZmllcj1jYXJ0by5IZWxsb01hcC1PYmplY3RpdmUtQwp3YXRlcm1hcms9Y2FydG9kYgp2YWxpZFVudGlsPTIwMTYtMTAtMDEKb25saW5lTGljZW5zZT0xCg==";
    
    // The initial step: register your license.
    // This must be done before using MapView
    [NTMapView registerLicense:License];
    

    return YES;
}

@end
