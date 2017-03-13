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
    self.bbox.minLon = -73.4768;
    self.bbox.maxLon = -74.1205;
    self.bbox.minLat = 40.4621;
    self.bbox.maxLat = 41.0043;
    
    NTProjection *proj = [[self.mapView getOptions]getBaseProjection];
    
    // Zoom to center of bbox
    [self.mapView setFocusPos:[proj fromWgs84:[self.bbox getCenter]]  durationSeconds:0];
    [self.mapView setZoom:8 durationSeconds:0];
    
    self._packageManagerListener.PackageName = [self.bbox toString];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self alert:@"This example downloads a routing package (not a map package) of New York"];
}

@end
