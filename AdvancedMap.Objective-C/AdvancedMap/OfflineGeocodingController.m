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

@end
