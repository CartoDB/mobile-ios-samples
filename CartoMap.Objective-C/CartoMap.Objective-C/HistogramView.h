//
//  HistogramView.h
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 03/03/17.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistogramView : UIView

@property CGFloat IntervalWidth;

@property (nonatomic, strong) NSMutableArray *intervals;

- (NSUInteger)getCount;

- (void)Initialize: (int)frameCount;

- (void)UpdateIntervalWidth;

- (void)UpdateAll: (int)maxElements;

- (void)UpdateElement: (int)frameNumber count: (int)elementCount max: (int)maxElements;

- (void)SetIntervalColor: (UIColor *)color;

@end
