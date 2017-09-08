//
//  GeocodingBaseController.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//
// Serves as the base class for both normal and reverse geocoding
//

/*
 * Base class for both reverse and normal geocoding
 */

#import <Foundation/Foundation.h>
#import <CartoMobileSDK/CartoMobileSDK.h>
#import "MapBaseController.h"

@interface GeocodingBaseController : MapBaseController

- (NSString *)getFailMessage;
- (void)showResult:(NTGeocodingResult *)result title:(NSString *)title description:(NSString *)description goToPosition: (BOOL)goToPosition;

@property NTLocalVectorDataSource *geocodingSource;
@property NTVectorLayer *geocodingLayer;

- (NSString *)getApiKey;

- (NSString *)getPrettyAddress:(NTGeocodingResult *)result;

@end
