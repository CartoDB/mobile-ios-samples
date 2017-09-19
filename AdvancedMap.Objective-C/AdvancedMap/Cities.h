//
//  Cities.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 19/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoundingBox.h"

@interface City : NSObject

- (id)initWithName:(NSString*)name minLon:(double)minLon maxLon:(double)maxLon minLat:(double)minLat maxLat:(double)maxLat;

@property NSString *name;

@property BoundingBox *boundingBox;

@property double size;

- (BOOL)isDownloaded;

@end

@interface Cities : NSObject

+ (NSMutableArray *)getList;

+ (NSString *) findNameById: (NSString *)identifier;

@end
