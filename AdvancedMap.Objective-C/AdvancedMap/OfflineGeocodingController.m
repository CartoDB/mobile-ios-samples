//
//  OfflineGeocodingController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 22/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "BaseGeocodingController.h"

@interface OfflineGeocodingController : BaseGeocodingController

@end

@implementation OfflineGeocodingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *source = [GEOCODING_TAG stringByAppendingString: CARTO_VECTOR_SOURCE];
    NSString *folder = [self createFolder:@"com.carto.geocodingpackages"];
    
    [self.contentView setManager:source folder:folder];
    
    self.service = [[NTPackageManagerGeocodingService alloc] initWithPackageManager: self.contentView.manager];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.contentView hasLocalPackages]) {
        [self showInformationBanner:@"Type an address to see whether it can be found :)"];
    } else {
        [self showInformationBanner: @"Click the globe icon and download a geocoding package to continue"];
    }
}

- (void)downloadComplete:(NSString *)identifier {
    [self showInformationBanner:@"Click on the map to find out more about a location"];
}

- (void)showInformationBanner: (NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.contentView.banner showInformationWithText:text autoclose:YES];
    });
}

@end
