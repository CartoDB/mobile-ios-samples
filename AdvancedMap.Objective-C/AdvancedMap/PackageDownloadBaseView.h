//
//  PackageDownloadBaseView.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 18/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "MapBaseView.h"

@interface PackageDownloadBaseView : MapBaseView

@property PopupButton *downloadButton;

@property PackagePopupContent *packageContent;

@property NTCartoPackageManager *manager;

@end
