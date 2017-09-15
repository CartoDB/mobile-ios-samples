//
//  MapBaseView.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 15/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import <CartoMobileSDK/CartoMobileSDK.h>
#import <UIKit/UIKit.h>
#import "AdvancedMap_Objective_C-Swift.h"

@interface MapBaseView : UIView

@property Banner *banner;
@property NTMapView *mapView;
@property SlideInPopup *popup;

@property NSMutableArray *buttons;

@property CGFloat bannerHeight;
@property CGFloat bottomLabelHeight;
@property CGFloat smallPadding;

- (void)addButton:(PopupButton *)button;

@end
