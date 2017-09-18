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

@interface MapPackageController : PackageDownloadBaseController

@end

@implementation MapPackageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView = [[PackageDownloadBaseView alloc] init];
    self.view = self.contentView;
    
    NSString *folder = [self createFolder:@"com.carto.mappackages"];
    self.contentView.manager = [[NTCartoPackageManager alloc] initWithSource:CARTO_VECTOR_SOURCE dataFolder:folder];
}

//- (NSString *)getFolder {
//    return @"regionpackages";
//}
//
//- (NSString *)getSource {
//    return CARTO_VECTOR_SOURCE;
//}

//- (void)showMap
//{
//    PackageMapController* mapController = [[PackageMapController alloc] init];
//    mapController.packageManager = self.packageManager;
//    [self.navigationController pushViewController:mapController animated:YES];
//}

@end
