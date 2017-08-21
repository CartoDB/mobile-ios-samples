//
//  Package.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "Package.h"

@implementation Package

- (id)initWithPackageName:(NSString*)packageName packageInfo:(NTPackageInfo*)packageInfo packageStatus:(NTPackageStatus*)packageStatus
{
    _packageName = packageName;
    if (packageInfo) {
        _packageId = [packageInfo getPackageId];
        _packageInfo = packageInfo;
        _packageStatus = packageStatus;
    }
    return self;
}

@end
