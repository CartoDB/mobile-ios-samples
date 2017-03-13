//
//  RoutePackageManagerListener.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 13/03/17.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <CartoMobileSDK/CartoMobileSDK.h>
#import "UIView+Toast.h"
#import "AlertMenu.h"

@interface RoutePackageManagerListener : NTPackageManagerListener

- (void)onPackageListUpdated;
- (void)onPackageListFailed;
- (void)onPackageUpdated:(NSString*)packageId version:(int)version;
- (void)onPackageCancelled:(NSString*)packageId version:(int)version;
- (void)onPackageFailed:(NSString*)packageId version:(int)version errorType:(enum NTPackageErrorType)errorType;
- (void)onPackageStatusChanged:(NSString*)packageId version:(int)version status:(NTPackageStatus*)status;

@property UIViewController *routingController;
@property NTPackageManager *packageManager;

@property NSString *PackageName;

@end

