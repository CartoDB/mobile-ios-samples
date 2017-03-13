//
//  RoutePackageManagerListener.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 13/03/17.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "RoutePackageManagerListener.h"
#import "OfflineRoutingBaseController.h"

@implementation RoutePackageManagerListener

- (void)getPackage:(NSString *)package
{
    NTPackageStatus* status = [_packageManager getLocalPackageStatus: package version:-1];
    
    if (status == nil) {
        [_packageManager startPackageDownload: package];
    } else if ([status getCurrentAction] == NT_PACKAGE_ACTION_READY) {
        
        ((OfflineRoutingBaseController*)self.routingController).isPackageDownloaded = YES;
        
        [(OfflineRoutingBaseController*)self.routingController alert:[NSString stringWithFormat:@"Routing package %@ downloaded", package ]];
    }
}

- (void)onPackageListUpdated
{
    NSLog(@"onPackageListUpdated");
    // We have packages all country/regions
    // You can download several packages, and route is found through all of them
    
    [self getPackage:self.PackageName];
}

- (void)onPackageListFailed
{
    NSLog(@"onPackageListFailed");
}

- (void)onPackageUpdated:(NSString*)packageId version:(int)version
{
    ((OfflineRoutingBaseController*)self.routingController).isPackageDownloaded = YES;
}

- (void)onPackageCancelled:(NSString*)packageId version:(int)version
{
}

- (void)onPackageFailed:(NSString*)packageId version:(int)version errorType:(enum NTPackageErrorType)errorType
{
    NSLog(@"onPackageFailed");
}

- (void)onPackageStatusChanged:(NSString*)packageId version:(int)version status:(NTPackageStatus*)status
{
    NSLog(@"onPackageStatusChanged progress: %f", [status getProgress]);
}

@end
