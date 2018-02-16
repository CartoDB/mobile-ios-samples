//
//  OnlineReverseGeocodingController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "BaseReverseGeocodingController.h"

@interface OnlineReverseGeocodingController : BaseReverseGeocodingController

@end

@implementation OnlineReverseGeocodingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [[NTPeliasOnlineReverseGeocodingService alloc]initWithApiKey:MAPZEN_API_KEY];

    [self hidePackageDownloadButton];

    // Zoom to Washington
    NTProjection* proj = [[self.contentView.mapView getOptions] getBaseProjection];
    NTMapPos* pos = [proj fromWgs84:[[NTMapPos alloc] initWithX:-77.004590 y:38.888702]];
    [self.contentView.mapView setFocusPos:pos durationSeconds:0];
    [self.contentView.mapView setZoom: 16.0f durationSeconds:0];
}

- (void)hidePackageDownloadButton {
    // For the sake of brevity and convenience,
    // both Online and Offline Reverse Geocoding controllers inherit from PackageDownloadBaseView.
    // Since this is our online sample, simply hide download the button,
    // PackageManager isn't initialized either, as it's not used
    [[self.contentView.buttons objectAtIndex:0] setHidden:YES];
}

@end
