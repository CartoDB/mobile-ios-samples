//
//  TorqueView.m
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 03/03/17.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import "TorqueView.h"

@implementation TorqueView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.MapView = [[NTMapView alloc]init];
        [self addSubview:self.MapView];
        
        self.Histogram = [[TorqueHistogram alloc]init];
        [self addSubview:self.Histogram];
    }
    
    return self;
}

- (void)layoutSubviews
{
    CGRect bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.MapView setFrame:bounds];
    
    CGFloat padding = 5;
    
    CGFloat h = 70;
    CGFloat w = bounds.size.width - 2 * padding;
    CGFloat x = padding;
    CGFloat y = bounds.size.height - (padding + h);
    
    self.Histogram.Margin = 5;
    [self.Histogram setFrame:CGRectMake(x, y, w, h)];
}

@end
