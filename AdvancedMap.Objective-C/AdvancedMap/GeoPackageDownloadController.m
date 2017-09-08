//
//  GeoPackageDownloadController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 22/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseGeoPackageDownloadController.h"
#import "OfflineGeocodingController.h"

@interface GeoPackageDownloadController : BaseGeoPackageDownloadController

@end

@implementation GeoPackageDownloadController

- (void)showMap
{
    OfflineGeocodingController* controller = [[OfflineGeocodingController alloc] init];
    controller.manager = self.packageManager;
    controller.service = [[NTPackageManagerGeocodingService alloc] initWithPackageManager:self.packageManager];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
