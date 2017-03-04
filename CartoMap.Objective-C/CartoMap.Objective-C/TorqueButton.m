//
//  TorqueButton.m
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 03/03/17.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import "TorqueButton.h"

@implementation TorqueButton

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.play_image  = [UIImage imageNamed:@"button_play"];
        self.pause_image = [UIImage imageNamed:@"button_pause"];
        
        self.imageView = [[UIImageView alloc]init];
        
        [self.imageView setClipsToBounds:YES];
        
        [self addSubview:self.imageView];
        
        [self play];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [[self layer] setCornerRadius:[self frame].size.width / 2];
    
    CGFloat padding = [self frame].size.width / 10;
    
    CGFloat x = padding;
    CGFloat y = padding;
    CGFloat w = [self frame].size.width - 2 * padding;
    CGFloat h = w;
    
    [self.imageView setFrame:CGRectMake(x, y, w, h)];
}

- (void)pause {
    [self.imageView setImage:self.play_image];
    self.isPaused = YES;
}

- (void)play {
    [self.imageView setImage:self.pause_image];
    self.isPaused = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self animateAlpha:0.7f];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self isPaused]) {
        [self play];
    } else {
        [self pause];
    }
    
    [self animateAlpha:1.0f];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self animateAlpha:1.0f];
}

- (void)animateAlpha: (CGFloat)alpha
{
    [UIView animateWithDuration:1.2f animations:^{ [self setAlpha:alpha]; }];
}

@end










