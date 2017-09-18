//
//  PackageListener.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 18/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "PackageDownloadListener.h"

@implementation PackageDownloadListener

- (void)onPackageListUpdated {
    [self.delegate listDownloadComplete];
}

- (void)onPackageListFailed {
    [self.delegate listDownloadFailed];
}

- (void)onPackageUpdated:(NSString *)arg1 version:(int)version {
    [self.delegate downloadComplete:arg1];
}

- (void)onPackageFailed:(NSString *)arg1 version:(int)version errorType:(enum NTPackageErrorType)errorType {
    [self.delegate downloadFailed:&errorType];
}

- (void)onPackageStatusChanged:(NSString *)arg1 version:(int)version status:(NTPackageStatus *)status {
    [self.delegate statusChanged:arg1 status:status];
}

@end
