//
//  MapPackageController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CartoMobileSDK/CartoMobileSDK.h>
#import "PackageDownloadBaseController.h"
#import "Sources.h"

@interface OfflineMapController : PackageDownloadBaseController

@end

@implementation OfflineMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView = [[PackageDownloadBaseView alloc] init];
    self.view = self.contentView;
    
    NSString *source = CARTO_VECTOR_SOURCE;
    NSString *folder = [self createFolder:@"com.carto.mappackages"];
    
    [self.contentView setManager:source folder:folder];
}

@end
