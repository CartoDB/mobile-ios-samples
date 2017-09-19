//
//  RouteClickListener.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 19/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import <CartoMobileSDK/CartoMobileSDK.h>

@interface  RouteClickListener : NTMapEventListener

@property (strong, nonatomic) NTMapView* mapView;
@property (strong, nonatomic) UIViewController* routingController;

@property (strong, nonatomic) NTMapPos* startPos;
@property (strong, nonatomic) NTMapPos* stopPos;
@property (strong, nonatomic) NTLocalVectorDataSource* routeDataSource;
@property (strong, nonatomic) NTBalloonPopup* oldClickLabel;

@end;

