//
//  Package.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "Package.h"

@implementation Package

NSString *const BBOX_IDENTIFIER = @"bbox(";
NSString * const CUSTOM_REGION_FOLDER_NAME = @"CUSTOM REGIONS";

NSString * const READY = @"READY";
NSString * const QUEUED = @"QUEUED";
NSString * const ACTION_PAUSE = @"PAUSE";
NSString * const ACTION_RESUME = @"RESUME";
NSString * const ACTION_CANCEL = @"CANCEL";
NSString * const ACTION_DOWNLOAD = @"DOWNLOAD";
NSString * const ACTION_REMOVE = @"REMOVE";

- (id)initWithPackageName:(NSString*)packageName packageInfo:(NTPackageInfo*)packageInfo packageStatus:(NTPackageStatus*)packageStatus
{
    self.name = packageName;
    
    if (packageInfo) {
        self.identifier = [packageInfo getPackageId];
        self.info = packageInfo;
        self.status = packageStatus;
    }
    
    return self;
}

- (BOOL)isGroup {
    return self.status == nil && self.info == nil && ![self isCustomRegionFolder];
}

- (BOOL)isCustomRegionFolder {
    return self.name == CUSTOM_REGION_FOLDER_NAME;
}

- (BOOL)isCustomRegionPackage {
    
    if (self.identifier == nil) {
        return false;
    }
    
    return [self.identifier rangeOfString:BBOX_IDENTIFIER].location == NSNotFound;
}

- (NSString *)getStatusText {
    
    NSString *status = @"Available";
    
    status = [status stringByAppendingString:[self getVersionAndSize]];
    
    // Check if the package is downloaded/is being downloaded (so that status is not null)
    if (self.status != nil) {
        
        NTPackageAction action = [self.status getCurrentAction];
        
        if (action == NT_PACKAGE_ACTION_READY) {
            status = @"Ready";
            status = [status stringByAppendingString:[self getVersionAndSize]];
        } else if (action == NT_PACKAGE_ACTION_WAITING) {
            status = @"Queued";
        } else {
            
            if (action == NT_PACKAGE_ACTION_COPYING) {
                status = @"Copying";
            } else if (action == NT_PACKAGE_ACTION_DOWNLOADING) {
                status = @"Downloading";
            } else if (action == NT_PACKAGE_ACTION_REMOVING) {
                status = @"Removing";
            }
        }
        
        NSString *progress = [NSString stringWithFormat:@"%f", [self.status getProgress]];
        status = [[[status stringByAppendingString:@" "] stringByAppendingString:progress] stringByAppendingString:@"%"];
    }
    
    return status;
}

- (NSString *)getActionText {
    
    if (self.status == nil) {
        return  ACTION_DOWNLOAD;
    }
    
    if ([self.status getCurrentAction] == NT_PACKAGE_ACTION_READY) {
        return ACTION_REMOVE;
    }
    
    if ([self.status getCurrentAction] == NT_PACKAGE_ACTION_WAITING) {
        return ACTION_CANCEL;
    }
    
    if ([self.status isPaused]) {
        return  ACTION_RESUME;
    }
    
    return ACTION_PAUSE;
}

- (NSString *)getVersionAndSize {

    if ([self isCustomRegionPackage]) {
        return @"";
    }
    
    NSString *version = [NSString stringWithFormat:@"%d", [self.info getVersion]];
    version = [[@"v." stringByAppendingString:version] stringByAppendingString:@" ("];
    
    if ([self isSmallerThan1MB]) {
        return [version stringByAppendingString:@"<1MB)"];
    }
    
    NSString *size = [NSString stringWithFormat:@"%f", [self getSizeInMB]];
    return [[version stringByAppendingString:size] stringByAppendingString:@" MB)"];
}

- (CGFloat)getSizeInMB {
    double bytesInMB = 1048576.0f;
    double result = round( [self.info getSize] / bytesInMB * 10.0) / 10.0;
    return result;
}

- (BOOL)isSmallerThan1MB {
    return [self getSizeInMB] < 1.0f;
}

@end








