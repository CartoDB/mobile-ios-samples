//
//  BaseGeocodingController.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 22/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "PackageDownloadBaseController.h"
#import "Sources.h"

/*
 * Base class for normal geocoding
 */

@interface BaseGeocodingController : PackageDownloadBaseController <UITableViewDataSource, UITextFieldDelegate, UITableViewDelegate>

@property NTGeocodingService *service;

@property int searchRequestId;
@property int displayRequestId;

- (void)geoCode:(NSString *)text autoComplete:(BOOL)autocomplete;

@end
