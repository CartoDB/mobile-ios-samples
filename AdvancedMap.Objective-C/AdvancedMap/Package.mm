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
    return YES;
}

- (BOOL)isCustomRegionFolder {
    return YES;
}

- (NSString *)getStatusText {
    return @"";
}

- (NSString *)getActionText {
    return @"";
}

@end
