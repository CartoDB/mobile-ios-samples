#import "MyMapEventListener.h"

@interface  MyMapEventListener() {
}

@property (strong, nonatomic) NTMapView* mapView;

@property (strong, nonatomic) NTLocalVectorDataSource* vectorDataSource;

@property (strong, nonatomic) NTBalloonPopup* oldClickLabel;

@end;

@implementation MyMapEventListener

-(void)setMapView:(NTMapView*)mapView vectorDataSource:(NTLocalVectorDataSource*)vectorDataSource
{
    _mapView = mapView;
    _vectorDataSource = vectorDataSource;
}

-(void)onMapMoved
{
 // called very often, even just console logging can lag map movement animation
 // print new map bounding box:
    /*
    NTMapPos* topLeft = [[[_mapView getOptions] getBaseProjection] toWgs84:[_mapView screenToMap: [[NTScreenPos alloc] initWithX:0 y:0]]];
  
    int w = _mapView.frame.size.width * [[UIScreen mainScreen] scale];
    int h = _mapView.frame.size.height * [[UIScreen mainScreen] scale];
    NTMapPos* bottomRight = [[[_mapView getOptions] getBaseProjection] toWgs84:[_mapView screenToMap:  [[NTScreenPos alloc] initWithX:w y:h]]];
    NSLog(@"Map zoom %f",[_mapView getZoom]);
    NSLog(@"Map moved to (screen %d %d) topLeft %f %f bottomRight %f %f", w, h, [topLeft getX], [topLeft getY], [bottomRight getX], [bottomRight getY]);
     */
}

-(void)onMapClicked:(NTMapClickInfo*)mapClickInfo
{
    // Remove old click label
    if (_oldClickLabel)
    {
        [_vectorDataSource remove:_oldClickLabel];
        _oldClickLabel = nil;
    }
    
    NTBalloonPopup* clickPopup = [[NTBalloonPopup alloc] init];
    NTBalloonPopupStyleBuilder* styleBuilder = [[NTBalloonPopupStyleBuilder alloc] init];
    // Make sure this label is shown on top all other labels
    [styleBuilder setPlacementPriority:10];
    
    // Check the type of the click
    NSString* clickMsg;
    if ([mapClickInfo getClickType] == NT_CLICK_TYPE_SINGLE)
    {
        clickMsg = @"Single map click!";
    }
    else if ([mapClickInfo getClickType] == NT_CLICK_TYPE_LONG)
    {
        clickMsg = @"Long map click!";
    }
    else if ([mapClickInfo getClickType] == NT_CLICK_TYPE_DOUBLE)
    {
        clickMsg = @"Double map click!";
    }
    else if ([mapClickInfo getClickType] == NT_CLICK_TYPE_DUAL)
    {
        clickMsg = @"Dual map click!";
    }
    
    NTMapPos* clickPos = [mapClickInfo getClickPos];
    NTMapPos* wgs84Clickpos = [[[_mapView getOptions] getBaseProjection] toWgs84:clickPos];

    clickPopup = [[NTBalloonPopup alloc] initWithPos:[mapClickInfo getClickPos]
                                               style:[styleBuilder buildStyle]
                                               title:clickMsg
                                                desc:[NSString stringWithFormat:@"%f, %f", [wgs84Clickpos getY], [wgs84Clickpos getX]]];
    [_vectorDataSource add:clickPopup];
    _oldClickLabel = clickPopup;
  
    NSLog(@"%@ Location: %@", clickMsg, [NSString stringWithFormat:@"%f, %f", [wgs84Clickpos getY], [wgs84Clickpos getX]]);
}

@end
