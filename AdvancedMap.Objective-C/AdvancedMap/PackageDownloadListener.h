//
//  PackageListener.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 18/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import <CartoMobileSDK/CartoMobileSDK.h>

@protocol PackageDownloadDelegate <NSObject>
@optional

- (void)listDownloadComplete;
- (void)listDownloadFailed;

- (void)downloadComplete: (NSString *)identifier;
- (void)downloadFailed: (NTPackageErrorType *)error;
- (void)statusChanged: (NSString *)identifier status: (NTPackageStatus *)status;

@end

@interface PackageDownloadListener : NTPackageManagerListener

@property (nonatomic, weak) id <PackageDownloadDelegate> delegate;

@end
