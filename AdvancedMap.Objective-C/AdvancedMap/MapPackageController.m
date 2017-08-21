//
//  MapPackageController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CartoMobileSDK/CartoMobileSDK.h>
#import "PackageManagerController.h"

@interface MapPackageController : PackageManagerController

@end

@implementation MapPackageController

- (NSString *)getFolder {
    return @"regionpackages";
}

- (NSString *)getSource {
    return CARTO_VECTOR_SOURCE;
}

- (void)showMap
{
    PackageMapController* mapController = [[PackageMapController alloc] init];
    mapController.packageManager = self.packageManager;
    [self.navigationController pushViewController:mapController animated:YES];
}

@end
