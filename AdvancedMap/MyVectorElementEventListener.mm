#import "MyVectorElementEventListener.h"

@interface  MyVectorElementEventListener() {
}

@property (strong, nonatomic) NTMapView* mapView;

@property (strong, nonatomic) NTLocalVectorDataSource* vectorDataSource;

@property (strong, nonatomic) NTBalloonPopup* oldClickLabel;

@end;

@implementation MyVectorElementEventListener

-(void)setMapView:(NTMapView*)mapView vectorDataSource:(NTLocalVectorDataSource*)vectorDataSource
{
    _mapView = mapView;
    _vectorDataSource = vectorDataSource;
}

-(BOOL)onVectorElementClicked:(NTVectorElementClickInfo*)clickInfo
{
    // Remove old click label
    if (_oldClickLabel)
    {
        [_vectorDataSource remove:_oldClickLabel];
        _oldClickLabel = nil;
    }
    
    NTBalloonPopup* clickPopup = [[NTBalloonPopup alloc] init];
    NTBalloonPopupStyleBuilder* styleBuilder = [[NTBalloonPopupStyleBuilder alloc] init];
    // Configure style
    [styleBuilder setLeftMargins:[[NTBalloonPopupMargins alloc] initWithLeft:0 top:0 right:0 bottom:0]];
    [styleBuilder setTitleMargins:[[NTBalloonPopupMargins alloc] initWithLeft:6 top:3 right:6 bottom:3]];
    // Make sure this label is shown on top all other labels
    [styleBuilder setPlacementPriority:10];
    
    // Check the type of vector element
    NTVectorElement* vectorElement = [clickInfo getVectorElement];
    
    NSString* clickText = [[vectorElement getMetaDataElement:@"ClickText"] getString];
    
    NSString* desc = @"";
    for(int i=0; i<[[vectorElement getMetaData] size]; i++){
        NSString* key =[[vectorElement getMetaData] get_key:i];
        desc = [NSString stringWithFormat:@"%@%@ = %@\n", desc, key, [[vectorElement getMetaData] get:key]];
    }
    
    // zoom in for cluster clicks
    if ([vectorElement isKindOfClass:[NTBalloonPopup class]]){
        if([clickText isEqualToString:@"cluster"]){
            [_mapView zoom:2.0f targetPos:[clickInfo getElementClickPos] durationSeconds:0.5f];
            return YES;
        }
    }
    
    
    if ([vectorElement isKindOfClass:[NTBillboard class]])
    {
        NTBillboard* billboard = (NTBillboard*)vectorElement;
        // If the element is billboard, attach the click label to the billboard element
        clickPopup = [[NTBalloonPopup alloc] initWithBaseBillboard:billboard
                                                             style:[styleBuilder buildStyle]
                                                             title:clickText
                                                              desc:desc];
    }
    else
    {
        // for lines and polygons set label to click location
        clickPopup = [[NTBalloonPopup alloc] initWithPos:[clickInfo getElementClickPos]
                                                   style:[styleBuilder buildStyle]
                                                   title:clickText
                                                    desc:desc];
    }
    [_vectorDataSource add:clickPopup];
    _oldClickLabel = clickPopup;
    
    NSLog(@"Vector element clicked, metadata : '%@' desc %@", clickText, desc);
    return YES;
}

@end
