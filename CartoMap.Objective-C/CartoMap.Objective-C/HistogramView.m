//
//  HistogramView.m
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 03/03/17.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import "HistogramView.h"

/* ToruqeInterval class START */

@interface TorqueInterval : UIView

@property int ElementCount;

- (void)Update:(CGFloat)parentHeight count:(int)elementCount max:(int)maxElements;

- (void)Update:(CGFloat)parentHeight max:(int)maxElements;

- (void)UpdateLayout:(CGFloat)height margin:(CGFloat)margin;

@end

@implementation TorqueInterval

- (void)Update:(CGFloat)parentHeight count:(int)elementCount max:(int)maxElements
{
    if (elementCount == 0) {
        [self UpdateLayout:0 margin:0];
        return;
    }
    
    if (elementCount == self.ElementCount) {
        // no need to update
        return;
    }
    
    self.ElementCount = elementCount;
    
    int percent = (elementCount * 100) / maxElements;
    CGFloat height = (parentHeight * percent) / 100;
    CGFloat margin = parentHeight - height;
    
    [self UpdateLayout:height margin:margin];
}

- (void)Update:(CGFloat)parentHeight max:(int)maxElements
{
    int percent = (self.ElementCount * 100) / maxElements;
    CGFloat height = (parentHeight * percent) / 100;
    CGFloat margin = parentHeight - height;
    
    [self UpdateLayout:height margin:margin];
}

- (void)UpdateLayout:(CGFloat)height margin:(CGFloat)margin
{
    CGFloat x = [self frame].origin.x;
    CGFloat w = [self frame].size.width;
    [self setFrame:CGRectMake(x, margin, w, height)];
}

@end

/* ToruqeInterval class END */

@implementation HistogramView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.intervals = [[NSMutableArray alloc]init];
        [[self layer] setCornerRadius:3];
    }
    return self;
}

- (NSUInteger)getCount
{
    return [self.intervals count];
}

- (void)Initialize: (int)frameCount
{
    self.IntervalWidth = [self frame].size.width / frameCount;
    
    for (int i = 0; i < frameCount; i++)
    {
        TorqueInterval *interval = [[TorqueInterval alloc]init];
        [interval setFrame:CGRectMake(i * self.IntervalWidth, 0, self.IntervalWidth, 0)];
        
        [self addSubview:interval];
        [self.intervals addObject:interval];
    }
}

- (void)UpdateIntervalWidth
{
    self.IntervalWidth = [self frame].size.width / [self.intervals count];
    
    for (int i = 0; i < [self.intervals count]; i++)
    {
        TorqueInterval *interval = [self.intervals objectAtIndex:i];
        [interval setFrame:CGRectMake(i * self.IntervalWidth, [self frame].size.height - [interval frame].size.height, self.IntervalWidth, [interval frame].size.height)];
    }
}

- (void)UpdateAll: (int)maxElements
{
    for (int i = 0; i < [self.intervals count]; i++)
    {
        TorqueInterval *interval = [self.intervals objectAtIndex:i];
        [interval Update:[self frame].size.height max:maxElements];
    }
}

- (void)UpdateElement: (int)frameNumber count: (int)elementCount max: (int)maxElements
{
    TorqueInterval *interval = self.intervals[frameNumber];
    [interval Update:[self frame].size.height count:elementCount max:maxElements];
}

- (void)SetIntervalColor: (UIColor *)color
{
    for (int i = 0; i < [self.intervals count]; i++)
    {
        TorqueInterval *interval = [self.intervals objectAtIndex:i];
        [interval setBackgroundColor:color];
    }
}

@end













