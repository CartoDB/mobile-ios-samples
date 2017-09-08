//
//  PackageManagerController.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//


/*
 * Controller for package list manipulation.
 */
#import <Foundation/Foundation.h>
#import <CartoMobileSDK/CartoMobileSDK.h>
#import <GLKit/GLKit.h>
#import "PackageMapController.h"
#import "Sources.h"
#import "Package.h"
#import "PackageTableViewCell.h"
@class PackageManagerListener;

@interface PackageManagerController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

- (id)init;
- (id)initWithParent:(PackageManagerController*)parent folder:(NSString*)folder;
- (void)updatePackages;
- (void)updatePackage:(NSString*)packageId;
+ (void)displayToastWithMessage:(NSString*)toastMessage;

- (NSString *)getFolder;
- (NSString *)getSource;

@property(readonly) NSString* currentFolder;
@property(readonly) NSArray* currentPackages;

@property NTCartoPackageManager* packageManager;
@property PackageManagerListener* packageManagerListener;

@end
