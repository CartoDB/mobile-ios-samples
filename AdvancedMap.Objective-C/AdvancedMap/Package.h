//
//  Package.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

/*
 * A package holder containing package (or package group) name, package id, info and status.
 */
#import <Foundation/Foundation.h>
#import <CartoMobileSDK/CartoMobileSDK.h>

@interface Package : NSObject

- (id)initWithPackageName:(NSString*)packageName packageInfo:(NTPackageInfo*)packageInfo packageStatus:(NTPackageStatus*)packageStatus;

@property(readonly) NSString* packageName;
@property(readonly) NSString* packageId;
@property(readonly) NTPackageInfo* packageInfo;
@property NTPackageStatus* packageStatus;

@end
