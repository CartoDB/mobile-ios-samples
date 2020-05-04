//
//  MapOptions.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 22/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "MapOptions.h"

@implementation MapOption

- (id)initWithName:(NSString *)name tag:(NSString*)tag value:(BOOL)value {
    self.name = name;
    self.tag = tag;
    self.value = value;
    
    return self;
}

@end

@implementation MapOptions

+ (NSMutableArray *)getList {
    static NSMutableArray *list = nil;
    
    if (list == nil) {
        
        list = [[NSMutableArray alloc] init];
        
        [list addObject:[[MapOption alloc] initWithName:@"Globe view" tag:@"globe" value:NO]];
        [list addObject:[[MapOption alloc] initWithName:@"3D buildings" tag:@"buildings3d" value:NO]];
        [list addObject:[[MapOption alloc] initWithName:@"3D texts" tag:@"texts3d" value:YES]];
        [list addObject:[[MapOption alloc] initWithName:@"POIs" tag:@"pois" value:NO]];
    }
    
    return list;
}

@end
