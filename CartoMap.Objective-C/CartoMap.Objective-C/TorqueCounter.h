//
//  TorqueCounter.h
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 03/03/17.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TorqueCounter : UILabel

@property NSMutableArray *timestamps;

- (void)update: (int)frameNumber count: (int)frameCount;

@end
