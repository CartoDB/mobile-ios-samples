//
//  GeocodingView.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 19/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "GeocodingView.h"

@implementation GeocodingView

- (id) init {
    self = [super init];

    self.IDENTIFIER = @"result_table_id";
    
    self.darkTransparentGray = [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:200 / 255.0];
    self.lightTransparentGray = [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:120 / 255.0];
    self.transparent = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0 / 255.0];
    
    self.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    
    self.addresses = [[NSMutableArray alloc]init];
    
    self.inputField = [[UITextField alloc]init];
    [self.inputField setTextColor:UIColor.whiteColor];
    [self.inputField setBackgroundColor:self.darkTransparentGray];
    [self.inputField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.inputField setFont:self.font];
    // Text padding
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];
    [self.inputField setLeftView:view];
    [self.inputField setLeftViewMode:UITextFieldViewModeAlways];
    [self addSubview:_inputField];
    
    self.resultTable = [[UITableView alloc]init];
    [self.resultTable registerClass:[UITableViewCell class] forCellReuseIdentifier:self.IDENTIFIER];
    [self.resultTable setBackgroundColor:self.transparent];
    [self.resultTable setAllowsSelection:YES];
    [self.resultTable setUserInteractionEnabled:YES];
    [self addSubview:_resultTable];
    
    [self hideTable];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 5.0f;
    
    CGFloat x = padding;
    CGFloat y = Device.trueY0 + padding;
    CGFloat w = [self frame].size.width - 2 * padding;
    CGFloat h = 50;
    
    [self.inputField setFrame:CGRectMake(x, y, w, h)];
    
    y += h + 1;
    h = 240;
    
    [self.resultTable setFrame:CGRectMake(x, y, w, h)];
}


- (void)showTable {
    [self.resultTable setHidden:NO];
}

- (void)hideTable {
    [self.resultTable setHidden:YES];
}

- (void)closeTextField {
    [self.inputField resignFirstResponder];
    [self hideTable];
}

@end
