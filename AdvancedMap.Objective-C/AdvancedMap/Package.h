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

@property NSString *name;

@property NSString *identifier;

@property NTPackageInfo *info;

@property NTPackageStatus *status;

extern NSString * const BBOX_IDENTIFIER;
extern NSString * const CUSTOM_REGION_FOLDER_NAME;

extern NSString * const READY;
extern NSString * const QUEUED;
extern NSString * const ACTION_PAUSE;
extern NSString * const ACTION_RESUME;
extern NSString * const ACTION_CANCEL;
extern NSString * const ACTION_DOWNLOAD;
extern NSString * const ACTION_REMOVE;

- (BOOL)isGroup;

- (BOOL)isCustomRegionFolder;

- (BOOL)isCustomRegionPackage;

- (BOOL)isSmallerThan1MB;

- (NSString *)getStatusText;

- (NSString *)getActionText;

- (NSString *)getVersionAndSize;

- (CGFloat)getSizeInMB;

@end
