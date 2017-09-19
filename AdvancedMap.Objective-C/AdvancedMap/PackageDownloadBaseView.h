//
//  PackageDownloadBaseView.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 18/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "MapBaseView.h"
#import "Package.h"
#import "Cities.h"

@interface PackageDownloadBaseView : MapBaseView

@property PopupButton *downloadButton;
@property ProgressLabel *progressLabel;

@property PackagePopupContent *packageContent;
@property NTCartoPackageManager *manager;

- (NTProjection *)getProjection;

- (void)setManager: (NSString *)source folder: (NSString *)folder;
- (void)setOfflineLayer;

- (void)setPackageContent;
- (BOOL)isPackageContent;

- (void)listDownloadComplete;
- (void)statusChanged:(NSString *)identifier status: (NTPackageStatus *)status;
- (void)downloadComplete:(NSString *)identifier;

- (NSArray *)getPackages;
- (NSArray *)getCustomRegionPackages;

- (void)updateList;

- (void)onPackageClick: (Package *)package;
- (void)onBackButtonClick;

- (void)addDefaultBaseLayer;

@property NSMutableArray *downloadQueue;

@property NSString *folder;

@end
