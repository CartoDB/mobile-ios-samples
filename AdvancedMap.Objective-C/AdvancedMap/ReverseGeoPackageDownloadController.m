//
//  ReverseGeoPackageDownloadController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseGeoPackageDownloadController.h"
#import "OfflineReverseGeocodingController.h"

@interface ReverseGeoPackageDownloadController : BaseGeoPackageDownloadController

@end

@implementation ReverseGeoPackageDownloadController

- (void)showMap
{
    OfflineReverseGeocodingController* controller = [[OfflineReverseGeocodingController alloc] init];
    controller.manager = self.packageManager;
    controller.service = [[NTPackageManagerReverseGeocodingService alloc] initWithPackageManager:self.packageManager];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
    

