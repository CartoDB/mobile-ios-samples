//
//  BoundingBox.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 13/03/17.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import <CartoMobileSDK/CartoMobileSDK.h>

@interface BoundingBox : NSObject

@property double minLat;
@property double minLon;
@property double maxLat;
@property double maxLon;

- (NSString *)toString;
- (NTMapPos *)getCenter;

@end
