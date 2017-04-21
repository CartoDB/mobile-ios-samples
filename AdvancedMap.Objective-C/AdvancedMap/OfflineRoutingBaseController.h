//
//  OfflineRoutingBaseController.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 13/03/17.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "BaseRoutingController.h"
#import "RoutePackageManagerListener.h"

@interface OfflineRoutingBaseController : BaseRoutingController

@property NTCartoPackageManager* packageManager;
@property RoutePackageManagerListener* _packageManagerListener;

- (NSString *) getSource;
- (NSString *)getPackageDirectory;
- (NSString *)getAppSupportDirectory;
- (NTRoutingService *)getService;

@end


