//
//  PackageDownloadBaseController.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 18/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "MapBaseController.h"
#import "PackageDownloadListener.h"
#import "PackageDownloadBaseView.h"

@interface PackageDownloadBaseController : UIViewController<PackageDownloadDelegate>

@property PackageDownloadBaseView *contentView;

@property PackageDownloadListener *listener;

@end
