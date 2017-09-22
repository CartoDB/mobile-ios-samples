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

@property Banner * _Nonnull banner;
@property NTMapView * _Nonnull mapView;
@property SlideInPopup * _Nonnull popup;

@property NSMutableArray * _Nonnull buttons;

@property CGFloat bannerHeight;
@property CGFloat bottomLabelHeight;
@property CGFloat smallPadding;

- (void)addButton:(PopupButton *_Nonnull)button;

- (void)addRecognizer:(UIViewController *_Nonnull)sender view:(UIView *_Nonnull)view action: (nullable SEL)action;
- (void)removeRecognizerFrom:(UIView *_Nonnull)view;

- (void)addBaseLayer: (NTCartoBaseMapStyle)style;

- (void)setContent: (UIView *_Nullable)content;

@end
