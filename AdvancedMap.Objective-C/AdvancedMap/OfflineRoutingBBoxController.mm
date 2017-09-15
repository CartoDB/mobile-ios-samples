//
//  OfflineRoutingBBoxController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 13/03/17.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "OfflineRoutingBaseController.h"
#import "BoundingBox.h"

@interface OfflineRoutingBBoxController : OfflineRoutingBaseController

@property BoundingBox *bbox;

@end

@implementation OfflineRoutingBBoxController

-(void)viewDidLoad
{
    [super viewDidLoad];

    // bounding box of New York. Use e.g. bboxfinder.com to get yours
    self.bbox = [[BoundingBox alloc]init];
    self.bbox.minLon = -74.1205;
    self.bbox.maxLon = -73.4768;
    self.bbox.minLat = 40.4621;
    self.bbox.maxLat = 41.0043;
    
    NTProjection *proj = [[self.contentView.mapView getOptions]getBaseProjection];
    
    // Zoom to center of bbox
    [self.contentView.mapView setFocusPos:[proj fromWgs84:[self.bbox getCenter]]  durationSeconds:0];
    [self.contentView.mapView setZoom:10 durationSeconds:0];
    
    self._packageManagerListener.PackageName = [self.bbox toString];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self alert:@"This example downloads a routing package (not a map package) of New York"];
}

-(NTRoutingService *)getService
{
    
    return [[NTPackageManagerValhallaRoutingService alloc] initWithPackageManager:self.packageManager];
}

-(NSString *)getPackageDirectory
{
    return [[self getAppSupportDirectory] stringByAppendingString:@"/cityroutingpackages"];
}

@end
