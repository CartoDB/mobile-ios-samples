//
//  MapOptions.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 22/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapOption : NSObject

@property NSString *name;
@property NSString *tag;
@property BOOL value;

- (id)initWithName:(NSString *)name tag:(NSString*)tag value:(BOOL)value;

@end

@interface MapOptions : NSObject

+ (NSMutableArray *)getList;

@end
