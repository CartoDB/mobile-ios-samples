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

@end
