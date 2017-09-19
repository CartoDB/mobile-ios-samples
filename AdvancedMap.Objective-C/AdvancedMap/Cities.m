//
//  Cities.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 19/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "Cities.h"

@implementation City

- (id)initWithName:(NSString *)name minLon:(double)minLon maxLon:(double)maxLon minLat:(double)minLat maxLat:(double)maxLat {
    self.name = name;
    
    BoundingBox *box = [[BoundingBox alloc] init];
    box.minLon = minLon;
    box.maxLon = maxLon;
    box.minLat = minLat;
    box.maxLat = maxLat;
    
    self.boundingBox = box;
    
    return self;
}

- (BOOL)isDownloaded {
    return self.size > 0.0;
}

@end

@implementation Cities

+ (NSMutableArray *)getList {
    
    static NSMutableArray *list = nil;
    
    if (list == nil) {
        
        list = [[NSMutableArray alloc] init];
        
        City *city = [[City alloc] initWithName:@"Berlin" minLon: 13.2285 maxLon: 13.5046 minLat: 52.4698 maxLat: 52.5747];
        [list addObject:city];
        
        city = [[City alloc] initWithName:@"New York" minLon: -74.1205 maxLon: -73.4768 minLat: 40.4621 maxLat: 41.0043];
        [list addObject:city];
        
        city = [[City alloc] initWithName:@"Madrid" minLon: -3.7427 maxLon: -3.6432 minLat: 40.3825 maxLat: 40.4904];
        [list addObject:city];
        
        city = [[City alloc] initWithName:@"Paris" minLon: 2.1814 maxLon: 2.4356 minLat: 48.8089 maxLat: 48.9176];
        [list addObject:city];
        
        city = [[City alloc] initWithName:@"San Francisco" minLon: -122.5483 maxLon: -122.3382 minLat: 37.6642 maxLat: 37.8173];
        [list addObject:city];
        
        city = [[City alloc] initWithName:@"London" minLon: -0.5036 maxLon: 0.3276 minLat: 51.2871 maxLat: 51.6939];
        [list addObject:city];
        
        city = [[City alloc] initWithName:@"Mexico City" minLon: -99.3294 maxLon: -98.9373 minLat: 19.2515 maxLat: 19.6089];
        [list addObject:city];
        
        city = [[City alloc] initWithName:@"Barcelona" minLon: 2.0987 maxLon: 2.2494 minLat: 41.3456 maxLat: 41.4540];
        [list addObject:city];
        
        city = [[City alloc] initWithName:@"Tartu" minLon: 26.6548 maxLon: 26.7901 minLat: 58.3404 maxLat: 58.3964];
        [list addObject:city];
        
        city = [[City alloc] initWithName:@"New Delhi" minLon: 77.1477 maxLon: 77.2757 minLat: 28.5361 maxLat: 28.6368];
        [list addObject:city];
    }
    
    return list;
}

+ (NSString *)findNameById: (NSString *)identifier {
    
    NSMutableArray *list = [self getList];
    
    for (int i = 0; i < list.count; i++) {
        City *city = [list objectAtIndex:i];
        
        if ([city.boundingBox toString] == identifier) {
            return city.name;
        }
    }
    
    return @"";
}

@end







