//
//  Samples.h
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 28/09/2017.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sample : NSObject

@property NSString *title;
@property NSString *subtitle;
@property NSString *imageUrl;
@property NSString *controller;

@end

@interface Samples : NSObject

+ (NSMutableArray *)getList;

@end
