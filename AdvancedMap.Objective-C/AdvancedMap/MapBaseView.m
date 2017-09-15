//
//  MapBaseView.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 15/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "MapBaseView.h"

@implementation MapBaseView

- (id) init {
    self = [super init];
    
    self.mapView = [[NTMapView alloc] init];
    [self addSubview:self.mapView];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.mapView setFrame:self.bounds];
}

@end
