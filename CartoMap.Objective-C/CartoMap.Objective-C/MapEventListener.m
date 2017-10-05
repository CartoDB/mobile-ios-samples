//
//  MapEventListener.m
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 05/10/2017.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import "MapEventListener.h"

@implementation MapEventListener

- (void)onMapClicked: (NTMapClickInfo *)mapClickinfo {
    [self.source clear];
}

@end
