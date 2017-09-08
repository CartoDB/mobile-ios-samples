//
//  BaseGeocodingController.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 22/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "GeocodingBaseController.h"

/*
 * Base class for normal geocoding
 */

@interface BaseGeocodingController : GeocodingBaseController <UITableViewDataSource, UITextFieldDelegate, UITableViewDelegate>

@property NSString *IDENTIFIER;

@property NTGeocodingService *service;

@property UITextField *inputField;
@property UITableView *resultTable;

@property UIFont *font;
@property UIColor *lightTransparentGray;
@property UIColor *darkTransparentGray;
@property UIColor *transparent;

- (void)showTable;
- (void)hideTable;
- (void)closeTextField;

@property NSMutableArray *addresses;

@property int searchQueueSize;

- (void)geoCode:(NSString *)text autoComplete:(BOOL)autocomplete;
- (void)showResult:(NTGeocodingResult *)result;

@end
