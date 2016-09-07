#import "VectorMapSampleBaseController.h"

/*
 * A sample demonstrating how to handle vector tile click events and extract and
 * receive information about the clicked features. The sample uses NTVectorTileEventListener
 * interface to handle the vector tile clicks.
 */
@interface BaseMapInteractivitySampleController : VectorMapSampleBaseController

@property NTVectorLayer* vectorLayer;

@end

@interface BaseMapVectorTileEventListener : NTVectorTileEventListener

@property NTVectorLayer* vectorLayer;

@end

@implementation BaseMapInteractivitySampleController

- (void)updateBaseLayer
{
    [super updateBaseLayer];
    
    // Add overlay layer, if not yet added
    if (!self.vectorLayer) {
        NTProjection* proj = [[self.mapView getOptions] getBaseProjection];
        NTLocalVectorDataSource* vectorDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
        self.vectorLayer = [[NTVectorLayer alloc] initWithDataSource:vectorDataSource];
        [[self.mapView getLayers] add:self.vectorLayer];
    }
    
    // Attach custom listener to vector tile layer
    NTLayer* layer = [[self.mapView getLayers] get:0];
    if ([layer isKindOfClass:[NTVectorTileLayer class]]) {
        NTVectorTileLayer* vectorTileLayer = (NTVectorTileLayer*)layer;
        BaseMapVectorTileEventListener* myEventListener = [[BaseMapVectorTileEventListener alloc] init];
        myEventListener.vectorLayer = self.vectorLayer;
        [vectorTileLayer setVectorTileEventListener:myEventListener];
    }
}

@end

@implementation BaseMapVectorTileEventListener

- (BOOL)onVectorTileClicked:(NTVectorTileClickInfo *)clickInfo
{
    NTLocalVectorDataSource* dataSource = (NTLocalVectorDataSource*)[self.vectorLayer getDataSource];
    [dataSource clear];
    
    // Build overlay vector element
    NTFeature* feature = [clickInfo getFeature];
    NTGeometry* geom = [feature getGeometry];
    NTColor* color = [[NTColor alloc] initWithR:0 g:100 b:200 a:150];
    if ([geom isKindOfClass:[NTPointGeometry class]]) {
        NTPointStyleBuilder* builder = [[NTPointStyleBuilder alloc] init];
        [builder setColor: color];
        [dataSource add: [[NTPoint alloc] initWithGeometry:(NTPointGeometry*)geom style:[builder buildStyle]]];
    }
    if ([geom isKindOfClass:[NTLineGeometry class]]) {
        NTLineStyleBuilder* builder = [[NTLineStyleBuilder alloc] init];
        [builder setColor: color];
        [dataSource add: [[NTLine alloc] initWithGeometry:(NTLineGeometry*)geom style:[builder buildStyle]]];
    }
    if ([geom isKindOfClass:[NTPolygonGeometry class]]) {
        NTPolygonStyleBuilder* builder = [[NTPolygonStyleBuilder alloc] init];
        [builder setColor: color];
        [dataSource add: [[NTPolygon alloc] initWithGeometry:(NTPolygonGeometry*)geom style:[builder buildStyle]]];
    }
    
    // Add balloon popup to the click position
    NTBalloonPopup* clickPopup = [[NTBalloonPopup alloc] init];
    NTBalloonPopupStyleBuilder* styleBuilder = [[NTBalloonPopupStyleBuilder alloc] init];
    [styleBuilder setPlacementPriority:10];
    NSString* clickMsg = [[feature getProperties] description];
    clickPopup = [[NTBalloonPopup alloc] initWithPos:[clickInfo getClickPos]
                                                style:[styleBuilder buildStyle]
                                                title:@"Clicked"
                                                desc:clickMsg];
    [dataSource add:clickPopup];
    return YES;
}

@end
