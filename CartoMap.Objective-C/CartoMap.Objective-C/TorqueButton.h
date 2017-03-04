//
//  TorqueButton.h
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 03/03/17.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TorqueButton : UIView

@property CGFloat IntervalWidth;

@property NSMutableArray *intervals;

@property UIImage *play_image;
@property UIImage *pause_image;

@property UIImageView *imageView;

@property BOOL isPaused;

- (void)pause;

- (void)play;

- (void)animateAlpha: (CGFloat)alpha;

@end
