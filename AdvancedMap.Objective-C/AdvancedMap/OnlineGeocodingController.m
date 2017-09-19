//
//  OnlineGeocodingController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 22/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "BaseGeocodingController.h"
#import "Sources.h"

@interface OnlineGeocodingController : BaseGeocodingController

@end

@implementation OnlineGeocodingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [[NTPeliasOnlineGeocodingService alloc]initWithApiKey:MAPZEN_API_KEY];
    
    [self hidePackageDownloadButton];
}

- (void)hidePackageDownloadButton {
    // For the sake of brevity and convenience,
    // both Online and Offline Geocoding controllers inherit from PackageDownloadBaseView.
    // Since this is our online sample, simply hide download the button,
    // PackageManager isn't initialized either, as it's not used
    [[self.contentView.buttons objectAtIndex:0] setHidden:YES];
}

@end
