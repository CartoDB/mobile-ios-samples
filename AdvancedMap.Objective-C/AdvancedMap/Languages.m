//
//  Languages.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 22/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "Languages.h"

@implementation Language

- (id)initWithName:(NSString *)name value: (NSString *)value {
    self.name = name;
    self.value = value;
    
    return self;
}

@end

@implementation Languages

+ (NSMutableArray *)getList {
    static NSMutableArray *list = nil;
    
    if (list == nil) {
        
        list = [[NSMutableArray alloc] init];
        
        [list addObject:[[Language alloc] initWithName:@"Local" value:@""]];
        [list addObject:[[Language alloc] initWithName:@"English" value:@"en"]];
        [list addObject:[[Language alloc] initWithName:@"German" value:@"de"]];
        [list addObject:[[Language alloc] initWithName:@"Spanish" value:@"es"]];
        [list addObject:[[Language alloc] initWithName:@"Italian" value:@"it"]];
        [list addObject:[[Language alloc] initWithName:@"French" value:@"fr"]];
        [list addObject:[[Language alloc] initWithName:@"Russian" value:@"ru"]];
    }
    
    return list;
}

@end
