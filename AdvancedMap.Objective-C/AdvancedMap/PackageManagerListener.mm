//
//  PackageListener.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "PackageManagerListener.h"

@implementation PackageManagerListener

- (id)init
{
    _packageManagerControllers = [NSHashTable weakObjectsHashTable];
    return [super init];
}

- (void)addPackageManagerController:(PackageManagerController*)controller
{
    @synchronized(self) {
        [_packageManagerControllers addObject:controller];
    }
}

- (void)removePackageManagerController:(PackageManagerController*)controller
{
    @synchronized(self) {
        [_packageManagerControllers removeObject:controller];
    }
}

- (void)onPackageListUpdated
{
    @synchronized(self) {
        for (PackageManagerController* controller in _packageManagerControllers) {
            [controller updatePackages];
        }
    }
}

- (void)onPackageListFailed
{
    @synchronized(self) {
        for (PackageManagerController* controller in _packageManagerControllers) {
            [controller updatePackages];
        }
    }
    [PackageManagerController displayToastWithMessage:@"Failed to download package list"];
}

- (void)onPackageUpdated:(NSString*)packageId version:(int)version
{
    @synchronized(self) {
        for (PackageManagerController* controller in _packageManagerControllers) {
            [controller updatePackage:packageId];
        }
    }
}

- (void)onPackageCancelled:(NSString*)packageId version:(int)version
{
    @synchronized(self) {
        for (PackageManagerController* controller in _packageManagerControllers) {
            [controller updatePackage:packageId];
        }
    }
}

- (void)onPackageFailed:(NSString*)packageId version:(int)version errorType:(enum NTPackageErrorType)errorType
{
    @synchronized(self) {
        for (PackageManagerController* controller in _packageManagerControllers) {
            [controller updatePackage:packageId];
        }
    }
    [PackageManagerController displayToastWithMessage:@"Failed to download package"];
}

- (void)onPackageStatusChanged:(NSString*)packageId version:(int)version status:(NTPackageStatus*)status
{
    @synchronized(self) {
        for (PackageManagerController* controller in _packageManagerControllers) {
            [controller updatePackage:packageId];
            NSLog(@"onPackageStatusChanged progress: %f", [status getProgress]);
        }
    }
}

@end

