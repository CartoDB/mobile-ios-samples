//
//  ReverseGeocodingBaseController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "BaseReverseGeocodingController.h"

@interface ReverseGeocodingListener : NTMapEventListener

- (void)onMapClicked: (NTMapClickInfo *)mapClickinfo;

@property (nonatomic, strong) BaseReverseGeocodingController *controller;

@end

@interface BaseReverseGeocodingController ()

@property ReverseGeocodingListener *geocodingListener;

@end

@implementation BaseReverseGeocodingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView = [[GeocodingBaseView alloc] init];
    self.view = self.contentView;
    
    [self.contentView addDefaultBaseLayer];
    
    self.geocodingListener = [[ReverseGeocodingListener alloc]init];
    self.geocodingListener.controller = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.contentView.mapView setMapEventListener:self.geocodingListener];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.contentView.mapView setMapEventListener:nil];
    
    self.geocodingListener.controller = nil;
}

@end

@implementation ReverseGeocodingListener

- (void)onMapClicked: (NTMapClickInfo *)mapClickinfo {
    
    NTMapPos *location = [mapClickinfo getClickPos];
    NTProjection *projection = [self.controller.contentView getProjection];
    
    NTReverseGeocodingRequest *request = [[NTReverseGeocodingRequest alloc]initWithProjection:projection location:location];
    [request setSearchRadius:125.0f];
    
    // Scan the results list. If we found relatively close point-based match,
    // use this instead of the first result.
    // In case of POIs within buildings, this allows us to hightlight POI instead of the building
    NTGeocodingResultVector *results = [self.controller.service calculateAddresses: request];
    
    NTGeocodingResult *result;
    int count = (int)[results size];
    
    if (count > 0) {
        result = [results get:0];
    }
    
    for (int i = 0; i < count; i++) {
        
        NTGeocodingResult *other = [results get:i];
        
        // 0.8f means 125 * (1.0 - 0.9) = 12.5 meters (rank is relative distance)
        if ([other getRank] > 0.9f) {
            NSString *name = [[other getAddress] getName];
            
            if (name != nil && ![name  isEqual: @""]) {
                result = other;
                break;
            }
        }
    }
    
    NSString *title = @"";
    NSString *description = result.description;
    BOOL goToPosition = NO;
    
    GeocodingBaseView *view = (GeocodingBaseView *)self.controller.contentView;
    
    if (result == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *text = @"Couldn't find any results...";
            [view.banner showInformationWithText:text autoclose:YES];
        });
        return;
    }
    
    [view showResult:result title:title description:description goToPosition:goToPosition];
}

@end







