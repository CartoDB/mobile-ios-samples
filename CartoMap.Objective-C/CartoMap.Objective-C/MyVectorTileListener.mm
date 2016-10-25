
#import "MyVectorTileListener.h"

@implementation MyVectorTileListener

- (BOOL)onVectorTileClicked:(NTVectorTileClickInfo *)clickInfo
{
    NTLocalVectorDataSource* dataSource = (NTLocalVectorDataSource*)[self.vectorLayer getDataSource];
    [dataSource clear];
    
    // Build overlay vector element
    NTFeature* feature = [clickInfo getFeature];
    NTGeometry* geom = [feature getGeometry];
    
    NTColor* color = [[NTColor alloc] initWithR:0 g:100 b:200 a:150];
    
    NTPointStyleBuilder* pointStyleBuilder = [[NTPointStyleBuilder alloc] init];
    [pointStyleBuilder setColor: color];
    
    NTLineStyleBuilder* lineStyleBuilder = [[NTLineStyleBuilder alloc] init];
    [lineStyleBuilder setColor: color];
    
    NTPolygonStyleBuilder* polygonStyleBuilder = [[NTPolygonStyleBuilder alloc] init];
    [polygonStyleBuilder setColor: color];
    
    if ([geom isKindOfClass:[NTPointGeometry class]]) {
        [dataSource add: [[NTPoint alloc] initWithGeometry:(NTPointGeometry*)geom style:[pointStyleBuilder buildStyle]]];
    }
    if ([geom isKindOfClass:[NTLineGeometry class]]) {
        [dataSource add: [[NTLine alloc] initWithGeometry:(NTLineGeometry*)geom style:[lineStyleBuilder buildStyle]]];
    }
    if ([geom isKindOfClass:[NTPolygonGeometry class]]) {
        [dataSource add: [[NTPolygon alloc] initWithGeometry:(NTPolygonGeometry*)geom style:[polygonStyleBuilder buildStyle]]];
    }
    if ([geom isKindOfClass:[NTMultiGeometry class]]) {
        NTGeometryCollectionStyleBuilder* geomCollectionStyleBuilder = [[NTGeometryCollectionStyleBuilder alloc] init];
        [geomCollectionStyleBuilder setPointStyle:[pointStyleBuilder buildStyle]];
        [geomCollectionStyleBuilder setLineStyle:[lineStyleBuilder buildStyle]];
        [geomCollectionStyleBuilder setPolygonStyle:[polygonStyleBuilder buildStyle]];
        [dataSource add: [[NTGeometryCollection alloc] initWithGeometry:(NTMultiGeometry*)geom style:[geomCollectionStyleBuilder buildStyle]]];
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
    
    // if returns YES then no extra events. If NO then can be called again for next elements.
    // use mapListener.onMapClicked() event to know that all other events are finished
    
    return YES;
}

@end
