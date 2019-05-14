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
#import "GeocodingView.h"
#import "Sources.h"

@interface BaseGeocodingController ()

@end

@implementation BaseGeocodingController

- (GeocodingView *)getGeocodingView {
    return (GeocodingView *)self.contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView = [[GeocodingView alloc] init];
    self.view = self.contentView;
    
    [self.contentView addDefaultBaseLayer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self getGeocodingView].inputField setDelegate:self];
    [[self getGeocodingView].resultTable setDelegate:self];
    [[self getGeocodingView].resultTable setDataSource:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[self getGeocodingView].inputField setDelegate:nil];
    [[self getGeocodingView].resultTable setDelegate:nil];
    [[self getGeocodingView].resultTable setDataSource:nil];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [[self getGeocodingView] closeTextField];
    NSString *text = [[self getGeocodingView].inputField text];
    [self geoCode:text autoComplete:false];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    [[self getGeocodingView] showTable];
    
    NSString *substring = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    [self geoCode:substring autoComplete:true];
    
    return true;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // This controller contains a view with two tableViews,
    // one for package popup and the other for geocoding results.
    // Check the type and see which was called
    if (tableView == [self getGeocodingView].packageContent.table) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        [[self getGeocodingView] closeTextField];
        NTGeocodingResult *result = [[self getGeocodingView].addresses objectAtIndex:indexPath.row];
        [[self getGeocodingView] showAndGoToResult:result];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self getGeocodingView].addresses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self getGeocodingView].IDENTIFIER forIndexPath:indexPath];
    
    NTGeocodingResult *result = [[self getGeocodingView].addresses objectAtIndex:indexPath.row];
    
    [cell setTag:indexPath.row];
    [cell setBackgroundColor:[self getGeocodingView].lightTransparentGray];
    
    [[cell textLabel] setText:[[self getGeocodingView] getPrettyAddress:result]];
    [[cell textLabel] setFont:[self getGeocodingView].font];
    [[cell textLabel] setTextColor:UIColor.whiteColor];
    [[cell textLabel] setBackgroundColor:[self getGeocodingView].transparent];
    
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
        
        NTGeocodingRequest *request = [[NTGeocodingRequest alloc]initWithProjection:[[self getGeocodingView] getProjection] query:text];
        
        NTGeocodingResultVector *results = nil;
        @try {
            results = [self.service calculateAddresses:request];
        }
        @catch (NSException *ex) {
            NSLog(@"Geocoding failed: %@", ex);
        }
        if (results == nil) {
            return;
        }
        
        int count = [results size];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // In autocomplete mode just fill the autocomplete address list and reload tableview
            // In full geocode mode, show the result
            
            if (autocomplete) {
             
                [[self getGeocodingView].addresses removeAllObjects];
                
                for (int i = 0; i < count; i++) {
                    NTGeocodingResult *result = [results get:i];
                    [[self getGeocodingView].addresses addObject:result];
                }
                
                [[self getGeocodingView].resultTable reloadData];
                return;
            }
            
            if (count > 0) {
                NTGeocodingResult *result = [results get:0];
                [[self getGeocodingView] showAndGoToResult:result];
            }
        });
    });
}

@end







