//
//  OnlineGeocodingController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 22/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "BaseGeocodingController.h"

@interface OnlineGeocodingController : BaseGeocodingController

@end

@implementation OnlineGeocodingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [[NTPeliasOnlineGeocodingService alloc]initWithApiKey:[self getApiKey]];
}

@end
