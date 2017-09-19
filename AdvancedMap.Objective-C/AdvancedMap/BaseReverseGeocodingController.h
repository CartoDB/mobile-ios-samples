//
//  ReverseGeocodingBaseController.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "PackageDownloadBaseController.h"
#import "Sources.h"
#import "GeocodingBaseView.h"

@interface BaseReverseGeocodingController : PackageDownloadBaseController

@property (nonatomic, strong) NTReverseGeocodingService *service;

@end
