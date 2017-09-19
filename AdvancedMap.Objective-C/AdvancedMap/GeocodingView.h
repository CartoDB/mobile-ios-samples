//
//  GeocodingView.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 19/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "GeocodingBaseView.h"
#import <CartoMobileSDK/CartoMobileSDk.h>
#import <UIKit/UIKit.h>

@interface GeocodingView : GeocodingBaseView

@property NSString *IDENTIFIER;

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

@end
