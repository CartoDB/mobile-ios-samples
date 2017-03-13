//
//  OfflineRoutingPackageController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 13/03/17.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "OfflineRoutingBaseController.h"

@interface OfflineRoutingPackageController : OfflineRoutingBaseController

@end

@implementation OfflineRoutingPackageController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NTProjection *proj = [[self.mapView getOptions]getBaseProjection];
    NTMapPos *andorra = [[NTMapPos alloc]initWithX:1.5218 y:42.5063];
    
    // Zoom to Andorra as this is the package we're downloading
    [self.mapView setFocusPos:[proj fromWgs84:andorra]  durationSeconds:0];
    [self.mapView setZoom:10 durationSeconds:0];
    
    self._packageManagerListener.PackageName = @"AD-routing";
}

-(void)viewDidAppear:(BOOL)animated
{
    [self alert:@"This example downloads a routing package (not a map package) of Andorra, Europe"];
}

@end
