//
//  BaseGeoPackageDownloadActivity.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "BaseGeoPackageDownloadController.h"

@implementation BaseGeoPackageDownloadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView = [[PackageDownloadBaseView alloc] init];
    self.view = self.contentView;
    
    NSString *source = [ROUTING_TAG stringByAppendingString: CARTO_VECTOR_SOURCE];
    NSString *folder = [self createFolder:@"com.carto.geocodingpackages"];
    
    [self.contentView setManager:source folder:folder];
    
    [self.contentView addDefaultBaseLayer];
}

@end
