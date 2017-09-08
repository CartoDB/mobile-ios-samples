//
//  OnlineReverseGeocodingController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "OnlineReverseGeocodingController.h"
#import "GeocodingBaseController.h"

@interface OnlineReverseGeocodingController ()

@end

@implementation OnlineReverseGeocodingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [[NTPeliasOnlineReverseGeocodingService alloc]initWithApiKey:[self getApiKey]];
}

@end
