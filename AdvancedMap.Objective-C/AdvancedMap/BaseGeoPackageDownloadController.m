//
//  BaseGeoPackageDownloadActivity.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "BaseGeoPackageDownloadController.h"

@interface BaseGeoPackageDownloadController ()

@end

@implementation BaseGeoPackageDownloadController

- (NSString *)getFolder {
    return @"geocodingpackages";
}

- (NSString *)getSource {
    return [GEOCODING_TAG stringByAppendingString: OFFLINE_GEOCODING_SOURCE];
}

@end
