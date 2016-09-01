//
//  ViewController.m
//  HelloMap.Objective-C
//
//  Created by Aare Undo on 01/09/16.
//  Copyright © 2016 Aare Undo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)loadView {
    
    NSString* License = @"XTUMwQ0ZRQ2NSQjBQK1lWQURTMmxZdEpxNGtEMmFJNEcrUUlVS3RpdVFveFBFVDJjcmhGWkdNbjd4WVVpbUFFPQoKcHJvZHVjdHM9c2RrLWlvcy00LioKYnVuZGxlSWRlbnRpZmllcj1jYXJ0by5IZWxsb01hcC1PYmplY3RpdmUtQwp3YXRlcm1hcms9Y2FydG9kYgp2YWxpZFVudGlsPTIwMTYtMTAtMDEKb25saW5lTGljZW5zZT0xCg==";
    
    // The initial step: register your license.
    // This must be done before using MapView
    
    [NTMapView registerLicense:License];
    
    [super loadView];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // minimal map definition code
    
    // The storyboard has NTMapView connected as a view
    NTMapView* mapView = (NTMapView*) self.view;
    
    // Create online vector tile layer, use style asset embedded in the project
    NTBinaryData* styleData = [NTAssetUtils loadAsset:@"nutibright-v3.zip"];
    NTAssetPackage* assetPackage = [[NTZippedAssetPackage alloc] initWithZipData:styleData];
    NTVectorTileLayer* vectorTileLayer = [[NTCartoOnlineVectorTileLayer alloc] initWithSource: @"nutiteq.osm" styleAssetPackage:assetPackage];
    
    // Add vector tile layer
    [[mapView getLayers] add:vectorTileLayer];
}

@end
