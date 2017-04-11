//
//  TorqueHistogram.m
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 03/03/17.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import "TorqueHistogram.h"

@implementation TorqueHistogram

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIColor *cartoTransparent = RGBA(215, 82, 75, 200);
        UIColor *carto = RGB(215, 82, 75);
        UIColor *indicator = RGB(14, 122, 254);
        self.IntervalColor = [UIColor whiteColor];
        
        self.Counter = [[TorqueCounter alloc]init];
        [self.Counter setBackgroundColor:cartoTransparent];
        [self addSubview:self.Counter];
        
        self.HistogramView = [[HistogramView alloc]init];
        [self.HistogramView setBackgroundColor:cartoTransparent];
        [self addSubview:self.HistogramView];
        
        self.Button = [[TorqueButton alloc]init];
        [self.Button setBackgroundColor:carto];
        [self addSubview:self.Button];
        
        self.Indicator = [[TorqueIndicator alloc]init];
        [self.Indicator setBackgroundColor:indicator];
        [self addSubview:self.Indicator];
    }
    return self;
}

- (void)layoutSubviews
{
    self.TotalHeight = [self frame].size.height;
    self.BarHeight = self.TotalHeight / 1.65;
    self.ButtonHeight = self.BarHeight;
    self.CounterHeight = self.TotalHeight / 3.3;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.CounterHeight * 4;
    CGFloat h = self.CounterHeight;
    
    CGFloat min = 150.0f;
    if (w < min) {
        w = min;
    }
    
    [self.Counter setFrame:CGRectMake(x, y, w, h)];
    
    y = self.CounterHeight + self.Margin;
    w = [self frame].size.width / 3 * 2;
    h = self.BarHeight;
    
    [self.HistogramView setFrame:CGRectMake(x, y, w, h)];
    
    w = self.ButtonHeight;
    h = self.ButtonHeight;
    x = [self frame].size.width - w;
    y = [self frame].size.height - h;
    
    [self.Button setFrame:CGRectMake(x, y, w, h)];
}

- (void)OnOrientationChange
{
    [self.HistogramView UpdateIntervalWidth];
    
    CGRect frame = CGRectMake(0, self.CounterHeight + self.Margin / 2, self.HistogramView.IntervalWidth, self.BarHeight + self.Margin);
    [self.Indicator setFrame:frame];
}

- (void)Initialize: (int)frameCount
{
    self.HistogramView.IntervalWidth = [self.HistogramView frame].size.width / frameCount;
    
    [self.HistogramView Initialize:frameCount];
    [self.HistogramView SetIntervalColor:self.IntervalColor];
    
    CGRect frame = CGRectMake(0, self.CounterHeight + self.Margin / 2, self.HistogramView.IntervalWidth, self.BarHeight + self.Margin);
    [self.Indicator setFrame:frame];
}

- (void)UpdateElement: (int)frameNumber count: (int)elementCount max: (int)maxElements
{
    if ([self.HistogramView getCount] == 0) {
        return;
    }
    
    [self.HistogramView UpdateElement:frameNumber count:elementCount max:maxElements];
    [self.Indicator Update:frameNumber];
}

- (void)UpdateAll: (int)maxElements
{
    [self.HistogramView UpdateAll:maxElements];
}

@end








