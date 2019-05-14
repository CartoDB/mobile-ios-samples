//
//  OfflineReverseGeocodingActivity.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "BaseReverseGeocodingController.h"

@interface OfflineReverseGeocodingController : BaseReverseGeocodingController

@end

@implementation OfflineReverseGeocodingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *source = [GEOCODING_TAG stringByAppendingString: CARTO_VECTOR_SOURCE];
    NSString *folder = [self createFolder:@"com.carto.geocodingpackages"];
        
    [self.contentView setManager:source folder:folder];
        
    self.service = [[NTPackageManagerReverseGeocodingService alloc] initWithPackageManager: self.contentView.manager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.contentView hasLocalPackages]) {
        [self showInformationBanner:@"Click on the map to find out more about a location"];
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
