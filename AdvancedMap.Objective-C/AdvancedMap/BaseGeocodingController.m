//
//  BaseGeocodingController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 22/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

/*
 * Base class for normal geocoding
 */

#import "BaseGeocodingController.h"

@interface BaseGeocodingController ()

@end

@implementation BaseGeocodingController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    [self.view addSubview:_inputField];
    
    self.resultTable = [[UITableView alloc]init];
    [self.resultTable registerClass:[UITableViewCell class] forCellReuseIdentifier:self.IDENTIFIER];
    [self.resultTable setBackgroundColor:self.transparent];
    [self.resultTable setAllowsSelection:YES];
    [self.resultTable setUserInteractionEnabled:YES];
    [self.view addSubview:_resultTable];
    
    [self hideTable];
}

- (void)viewDidLayoutSubviews {
    
    CGFloat padding = 5.0f;
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication]statusBarFrame].size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGFloat x = padding;
    CGFloat y = statusBarHeight + navBarHeight + padding;
    CGFloat w = [self.view frame].size.width - 2 * padding;
    CGFloat h = 50;
    
    [self.inputField setFrame:CGRectMake(x, y, w, h)];
    
    y += h + 1;
    h = 240;
    
    [self.resultTable setFrame:CGRectMake(x, y, w, h)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.inputField setDelegate:self];
    [self.resultTable setDelegate:self];
    [self.resultTable setDataSource:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.inputField setDelegate:nil];
    [self.resultTable setDelegate:nil];
    [self.resultTable setDataSource:nil];
}

- (void)showTable {
    [self.resultTable setHidden:NO];
}

- (void)hideTable {
    [self.resultTable setHidden:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self closeTextField];
    NSString *text = [self.inputField text];
    [self geoCode:text autoComplete:false];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    [self showTable];
    
    NSString *substring = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    [self geoCode:substring autoComplete:true];
    
    return true;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self closeTextField];
    
    NTGeocodingResult *result = [self.addresses objectAtIndex:indexPath.row];
    [self showResult:result];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.addresses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.IDENTIFIER forIndexPath:indexPath];
    
    NTGeocodingResult *result = [self.addresses objectAtIndex:indexPath.row];
    
    [cell setTag:indexPath.row];
    [cell setBackgroundColor:self.lightTransparentGray];
    
    [[cell textLabel] setText:[self getPrettyAddress:result]];
    [[cell textLabel] setFont:self.font];
    [[cell textLabel] setTextColor:UIColor.whiteColor];
    [[cell textLabel]setBackgroundColor:self.transparent];
    
    return cell;
    
}

- (void)geoCode:(NSString *)text autoComplete:(BOOL)autocomplete {
    
    self.searchQueueSize += 1;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (self.searchQueueSize - 1 > 0) {
            // Cancel the request if we have additional pending requests queued
            return;
        }
        
        self.searchQueueSize -= 1;
        
        NTGeocodingRequest *request = [[NTGeocodingRequest alloc]initWithProjection:[self getProjection] query:text];
        
        NTGeocodingResultVector *results = [self.service calculateAddresses:request];
        int count = [results size];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // In autocomplete mode just fill the autocomplete address list and reload tableview
            // In full geocode mode, show the result
            
            if (autocomplete) {
             
                [self.addresses removeAllObjects];
                
                for (int i = 0; i < count; i++) {
                    NTGeocodingResult *result = [results get:i];
                    [self.addresses addObject:result];
                }
                
                [self.resultTable reloadData];
                return;
            }
            
            if (count > 0) {
                NTGeocodingResult *result = [results get:0];
                [self showResult:result];
            }
        });
    });
}

- (void)showResult:(NTGeocodingResult *)result {
    
    NSString *title = @"";
    NSString *description = [self getPrettyAddress:result];
    
    [self showResult:result title:title description:description goToPosition:true];
}

- (void)closeTextField {
    [self.inputField resignFirstResponder];
    [self hideTable];
}

@end







