//
//  Languages.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 22/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Language : NSObject

@property NSString *name;
@property NSString *value;

- (id)initWithName:(NSString *)name value: (NSString *)value;

@end

@interface Languages : NSObject

+ (NSMutableArray *)getList;

@end
