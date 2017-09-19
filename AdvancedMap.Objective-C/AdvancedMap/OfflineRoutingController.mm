//
//  OfflineRoutingPackageController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 13/03/17.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "BaseRoutingController.h"
#import "Sources.h"

@interface OfflineRoutingController : BaseRoutingController

@end

@implementation OfflineRoutingController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *source = [ROUTING_TAG stringByAppendingString: CARTO_VECTOR_SOURCE];
    NSString *folder = [self createFolder:@"com.carto.routingpackages"];
    
    [self.contentView setManager:source folder:folder];
    
    self.service = [[NTPackageManagerValhallaRoutingService alloc] initWithPackageManager:self.contentView.manager];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.contentView hasLocalPackages]) {
        [self showInformationBanner:@"Long Click on the map to set route positions"];
    } else {
        [self showInformationBanner: @"Click the globe icon and download a geocoding package to continue"];
    }
}

- (void)downloadComplete:(NSString *)identifier {
    [self showInformationBanner:@"Long Click on the map to set route positions"];
}

- (void)showInformationBanner: (NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.contentView.banner showInformationWithText:text autoclose:YES];
    });
}

@end
