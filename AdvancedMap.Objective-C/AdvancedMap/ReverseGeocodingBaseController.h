//
//  ReverseGeocodingBaseController.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "GeocodingBaseController.h"

@interface ReverseGeocodingBaseController : GeocodingBaseController

@property (nonatomic, strong) NTReverseGeocodingService *service;

@end
