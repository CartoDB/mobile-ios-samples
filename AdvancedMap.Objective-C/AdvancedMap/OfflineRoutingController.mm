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

-(void)viewDidAppear:(BOOL)animated
{
//    [self alert:@"This example downloads a routing package (not a map package) of Andorra, Europe"];
}

@end
