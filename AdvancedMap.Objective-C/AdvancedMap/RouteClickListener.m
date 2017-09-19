//
//  RouteClickListener.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 19/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "RouteClickListener.h"
#import "BaseRoutingController.h"

@implementation RouteClickListener

-(void)setVectorDataSource:(NTLocalVectorDataSource*)vectorDataSource
{
    _routeDataSource = vectorDataSource;
}

-(void)onMapMoved
{
    // do nothing
}

-(void)onMapClicked:(NTMapClickInfo*)mapClickInfo
{
    // Remove old click label
    if (_oldClickLabel)
    {
        [_routeDataSource remove:_oldClickLabel];
        _oldClickLabel = nil;
    }
    
    if ([mapClickInfo getClickType] == NT_CLICK_TYPE_LONG) {
        
        NTMapPos* clickPos = [mapClickInfo getClickPos];
        
        if(_startPos == nil) {
            _startPos = clickPos;
            [(BaseRoutingController *)self.routingController setStart: clickPos];
            
        } else if (_stopPos == nil) {
            
            _stopPos = clickPos;
            
            [(BaseRoutingController *)self.routingController setStop: clickPos];
            
            // restart to force new route next time
            _startPos = nil;
            _stopPos = nil;
        }
    }
}

-(void)onVectorElementClicked:(NTVectorElementClickInfo*)clickInfo
{
    // Remove old click label
    if (_oldClickLabel)
    {
        [_routeDataSource remove:_oldClickLabel];
        _oldClickLabel = nil;
    }
    
    // Check the type of vector element
    NTVectorElement* vectorElement = [clickInfo getVectorElement];
    
    NSString* desc = [[vectorElement getMetaDataElement:@"desc"] getString];
    NSString* title = [[vectorElement getMetaDataElement:@"title"] getString];
    
    if([desc isEqualToString:@""]) {
        return;
    }
    
    NTBalloonPopup* clickPopup = [[NTBalloonPopup alloc] init];
    NTBalloonPopupStyleBuilder* styleBuilder = [[NTBalloonPopupStyleBuilder alloc] init];
    
    [styleBuilder setPlacementPriority: 1]; // make sure it is on top of Markers
    
    if([title isEqualToString:@""]){
        
        // route description if clicked to line
        [styleBuilder setLeftColor:[[NTColor alloc] initWithColor:0xFF0000AA]]; // blue
        
        clickPopup = [[NTBalloonPopup alloc] initWithPos:[clickInfo getElementClickPos] style:[styleBuilder buildStyle] title:desc desc:@""];
        
    } else {
        [styleBuilder setLeftColor:[[NTColor alloc] initWithColor:0xFF00AA00]]; // green
        
        NTVectorElement* vectorElement = [clickInfo getVectorElement];
        
        if([vectorElement isKindOfClass:[NTBillboard class]]) {
            
            NTBillboard* billboard = (NTBillboard*)vectorElement;
            
            clickPopup = [[NTBalloonPopup alloc] initWithBaseBillboard:billboard style:[styleBuilder buildStyle] title:title desc:desc];
        }
    }
    
    [_routeDataSource add:clickPopup];
    _oldClickLabel = clickPopup;
}

@end
