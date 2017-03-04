//
//  TorqueHistogram.h
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 03/03/17.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistogramView.h"
#import "TorqueButton.h"
#import "TorqueCounter.h"
#import "TorqueIndicator.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0]

@interface TorqueHistogram : UIView

@property UIColor *IntervalColor;

@property CGFloat Margin;
@property CGFloat BarHeight;
@property CGFloat CounterHeight;
@property CGFloat ButtonHeight;
@property CGFloat TotalHeight;

@property HistogramView *HistogramView;

@property TorqueButton *Button;

@property TorqueCounter *Counter;

@property TorqueIndicator *Indicator;

- (void)OnOrientationChange;

- (void)Initialize: (int)frameCount;

- (void)UpdateElement: (int)frameNumber count: (int)elementCount max: (int)maxElements;

- (void)UpdateAll: (int)maxElements;

@end
