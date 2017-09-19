//
//  BaseRoutingView.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 19/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "PackageDownloadBaseView.h"

@interface BaseRoutingView : PackageDownloadBaseView

@property NTLocalVectorDataSource *routeDataSource;
@property NTLocalVectorDataSource *routeStartStopDataSource;

@property NTMarker *startMarker;
@property NTMarker *stopMarker;

@property NTMarkerStyle *instructionUp;
@property NTMarkerStyle *instructionLeft;
@property NTMarkerStyle *instructionRight;

- (void)setStart:(NTMapPos *)mapPos;
- (void)setStop:(NTMapPos *)mapPos;

- (NTMarker *)createRoutePoint: (NTRoutingInstruction*) instruction point:(NTMapPos*) pos;
- (NTLine *)calculateRouteLine: (NTRoutingResult*) result;

@end
