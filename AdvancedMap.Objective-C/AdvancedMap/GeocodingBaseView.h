//
//  GeocodingBaseView.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 19/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "PackageDownloadBaseView.h"

@interface GeocodingBaseView : PackageDownloadBaseView

@property NTLocalVectorDataSource *geocodingSource;
@property NTVectorLayer *geocodingLayer;

- (void)showAndGoToResult:(NTGeocodingResult *)result;
- (void)showResult:(NTGeocodingResult *)result title:(NSString *)title description:(NSString *)description goToPosition: (BOOL)goToPosition;

- (NSString *)getPrettyAddress:(NTGeocodingResult *)result;

@end
