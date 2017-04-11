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
        [self setFont: [UIFont fontWithName:@"Helvetica Neue" size:13]];
        [self setTextAlignment:NSTextAlignmentCenter];
        
        [[self layer] setCornerRadius:2];
        [self setClipsToBounds:YES];
    }
    
    return self;
}

- (void)update:(int)frameNumber count:(int)frameCount
{
    if (self.timestamps == nil)
    {
        int incrementBySeconds = 15;
        int layerCount = 256;
        
        self.timestamps = [[NSMutableArray alloc]init];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
    
        [components setYear:2016];
        [components setMonth:9];
        [components setDay:15];
        [components setHour:12];
        [components setMinute:14];
    
        NSDate *date = [calendar dateFromComponents:components];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"HH:mm:ss dd/MM/YYYY"];
       
        /*
         * Hardcoded (pretty) timestamp in accordance with the web UI.
         * Non-hardcoded currently only available via external api
         *
         * We know the start date, count and interval - just loop over it and create pretty timestamps
         */
        
        for (int i = 0; i < layerCount; i++) {
            
            NSString *timestamp = [NSString stringWithFormat:@"%@",[format stringFromDate:date]];
            [self.timestamps addObject:timestamp];
            
            date = [date dateByAddingTimeInterval:incrementBySeconds * 60];
        }
    }
    
    NSString *text = [self.timestamps objectAtIndex:frameNumber];
    [self setText:text];
}

@end
