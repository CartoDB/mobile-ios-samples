//
//  PackageListener.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//


/*
 * Package manager listener. Listener is notified about asynchronous events
 * about packages.
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CartoMobileSDK/CartoMobileSDK.h>
#import <GLKit/GLKit.h>
#import "PackageManagerController.h"

@interface PackageManagerListener : NTPackageManagerListener

- (id)init;
- (void)addPackageManagerController:(PackageManagerController*)controller;
- (void)removePackageManagerController:(PackageManagerController*)controller;

- (void)onPackageListUpdated;
- (void)onPackageListFailed;
- (void)onPackageUpdated:(NSString*)packageId version:(int)version;
- (void)onPackageCancelled:(NSString*)packageId version:(int)version;
- (void)onPackageFailed:(NSString*)packageId version:(int)version errorType:(enum NTPackageErrorType)errorType;
- (void)onPackageStatusChanged:(NSString*)packageId version:(int)version status:(NTPackageStatus*)status;

@property(readonly, atomic) NSHashTable* packageManagerControllers;

@end
