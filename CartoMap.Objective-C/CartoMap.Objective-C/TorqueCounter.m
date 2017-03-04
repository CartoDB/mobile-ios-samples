//
//  TorqueCounter.m
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 03/03/17.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import "TorqueCounter.h"

@implementation TorqueCounter

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self setTextColor:[UIColor whiteColor]];
        [self setFont: [UIFont fontWithName:@"Helvetica Neue" size:14]];
        [self setTextAlignment:NSTextAlignmentCenter];
        
        [[self layer] setCornerRadius:3];
        [self setClipsToBounds:YES];
    }
    
    return self;
}

- (void)update:(int)frameNumber count:(int)frameCount
{
    NSString *number = @"";
    
    // TODO make more generic, currently works with this sample
    if (frameCount > 100) {
        
        if (frameCount < 10) {
            number = [NSString stringWithFormat:@"00%d/%d", frameNumber, frameCount];
        } else if (frameCount < 100) {
            number = [NSString stringWithFormat:@"0%d/%d", frameNumber, frameCount];
        } else {
            number = [NSString stringWithFormat:@"%d/%d", frameNumber, frameCount];
        }
    }
    
    [self setText:number];
}

@end
