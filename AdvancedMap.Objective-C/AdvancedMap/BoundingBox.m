//
//  BoundingBox.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 13/03/17.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "BoundingBox.h"

@implementation BoundingBox

- (NTMapPos *)getCenter
{
    double x = (self.maxLon + self.minLon) / 2;
    double y = (self.maxLat + self.minLat) / 2;
    
    return [[NTMapPos alloc]initWithX:x y:y];
}

- (NSString *)toString;
{
    NSString *minLat = [NSString stringWithFormat:@"%.04f", self.minLat];
    NSString *minLon = [NSString stringWithFormat:@"%.04f", self.minLon];
    NSString *maxLat = [NSString stringWithFormat:@"%.04f", self.maxLat];
    NSString *maxLon = [NSString stringWithFormat:@"%.04f", self.maxLon];

    return [[[[[[[[@"bbox("
                   stringByAppendingString:minLon] stringByAppendingString:@","]
                 stringByAppendingString:minLat] stringByAppendingString:@","]
               stringByAppendingString:maxLon]stringByAppendingString:@","]
             stringByAppendingString:maxLat] stringByAppendingString:@")"];
}

@end
