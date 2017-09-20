//
//  BaseRoutingView.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 19/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "BaseRoutingView.h"

@implementation BaseRoutingView

- (id) init {
    self = [super init];

    // Get the base projection set in the base class
    NTProjection* proj = [[self.mapView getOptions] getBaseProjection];
    
    // Initialize an online vector data source for base map
    _routeDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
    _routeStartStopDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
    
    // Initialize a vector layer with the previous data source
    NTVectorLayer* vectorLayer = [[NTVectorLayer alloc] initWithDataSource:_routeDataSource];
    NTVectorLayer* vectorLayerStartStop = [[NTVectorLayer alloc] initWithDataSource:_routeStartStopDataSource];
    
    // Add the previous vector layer to the map
    [[self.mapView getLayers] add:vectorLayer];
    [[self.mapView getLayers] add:vectorLayerStartStop];
    
    // Create markers for start and end
    NTMarkerStyleBuilder* markerStyleBuilder = [[NTMarkerStyleBuilder alloc] init];
    [markerStyleBuilder setSize:30];
    [markerStyleBuilder setHideIfOverlapped:NO];
    [markerStyleBuilder setColor:[[NTColor alloc] initWithColor:0xFF00FF00]]; // Green
    
    // Initial empty markers
    _startMarker = [[NTMarker alloc] initWithPos:[[NTMapPos alloc] initWithX:0 y:0] style:[markerStyleBuilder buildStyle]];
    [_startMarker setVisible:NO];
    [_routeStartStopDataSource add: _startMarker];
    
    // Change color to Red
    [markerStyleBuilder setColor:[[NTColor alloc] initWithColor:0xFFFF0000]];
    
    _stopMarker = [[NTMarker alloc] initWithPos:[[NTMapPos alloc] initWithX:0 y:0] style:[markerStyleBuilder buildStyle]];
    [_stopMarker setVisible:NO];
    [_routeStartStopDataSource add: _stopMarker];
    
    // Create styles for instruction markers
    [markerStyleBuilder setColor: [[NTColor alloc] initWithColor:0xFFFFFFFF]]; // white
    [markerStyleBuilder setBitmap:[NTBitmapUtils createBitmapFromUIImage:[UIImage imageNamed:@"direction_up.png"]]];
    _instructionUp = [markerStyleBuilder buildStyle];
    
    [markerStyleBuilder setBitmap:[NTBitmapUtils createBitmapFromUIImage:[UIImage imageNamed:@"direction_upthenleft.png"]]];
    _instructionLeft = [markerStyleBuilder buildStyle];
    
    [markerStyleBuilder setBitmap:[NTBitmapUtils createBitmapFromUIImage:[UIImage imageNamed:@"direction_upthenright.png"]]];
    _instructionRight = [markerStyleBuilder buildStyle];
    
    return self;
}

- (void)setStart:(NTMapPos*)mapPos {
    [_routeDataSource clear];
    [_stopMarker setVisible:NO];
    [_startMarker setPos:mapPos];
    [_startMarker setVisible:YES];
}

- (void)setStop:(NTMapPos *)mapPos {
    [_stopMarker setPos:mapPos];
    [_stopMarker setVisible:YES];
}

- (NTMarker*)createRoutePoint:(NTRoutingInstruction*) instruction point:(NTMapPos*) pos
{
    NTMarkerStyle* style = _instructionUp;
    
    if ([instruction getAction] == NT_ROUTING_ACTION_TURN_LEFT) {
        style = _instructionLeft;
    } else if ([instruction getAction] == NT_ROUTING_ACTION_TURN_RIGHT) {
        style = _instructionRight;
    }
    
    NTMarker* marker = [[NTMarker alloc] initWithPos:pos style:style];
    
    return marker;
}

- (NTLine*)calculateRouteLine:(NTRoutingResult*) result
{
    NTColor *color = [[NTColor alloc] initWithR:14 g:122 b:254 a:150];
    
    // Style for the line
    NTLineStyleBuilder* builder = [[NTLineStyleBuilder alloc] init];
    [builder setColor:color];
    [builder setWidth:12];
    
    return [[NTLine alloc] initWithPoses:[result getPoints] style:[builder buildStyle]];
}

@end




