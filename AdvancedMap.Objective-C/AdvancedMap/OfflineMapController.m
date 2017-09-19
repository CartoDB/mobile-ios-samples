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
    [self.contentView setOfflineLayer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![self.contentView hasLocalPackages]) {
        [self showInformationBanner: @"Click the globe icon and download a map package to continue"];
    }
}

- (void)showInformationBanner: (NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.contentView.banner showInformationWithText:text autoclose:YES];
    });
}

@end
