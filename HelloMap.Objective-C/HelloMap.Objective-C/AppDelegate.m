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
    
    NSString* License = @"XTUN3Q0ZBc2g3VFBoRGV3VUluZGJab3RZOEpLVll1MW5BaFFOUjNSaFE5MGNHK2kraFpsK3V0VU5BQ09UU1E9PQoKYXBwVG9rZW49MzNkNzY2NTAtNjZjNy00YjJlLTkyMWYtMDczMzBmZWNmMDNkCmJ1bmRsZUlkZW50aWZpZXI9Y29tLmNhcnRvLmhlbGxvbWFwCm9ubGluZUxpY2Vuc2U9MQpwcm9kdWN0cz1zZGstaW9zLTQuKgp3YXRlcm1hcms9Y3VzdG9tCg==";
    
    // The initial step: register your license.
    // This must be done before using MapView
    [NTMapView registerLicense:License];
    

    return YES;
}

@end
