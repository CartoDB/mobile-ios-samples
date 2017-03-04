//
//  TorqueIndicator.m
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 03/03/17.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import "TorqueIndicator.h"

@implementation TorqueIndicator

- (void)Update:(int)frameNumber
{
    CGFloat x = [self frame].size.width * frameNumber;
    [self setFrame:CGRectMake(x, [self frame].origin.y, [self frame].size.width, [self frame].size.height)];
}

@end
