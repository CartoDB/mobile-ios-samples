
#import "BaseVisController.h"

/*
 * A sample demonstrating how to use high-level Carto VisJSON API.
 * A list of different visjson URLs can be selected from the menu.
 * CartoVisLoader class is used to load and configure all corresponding layers.
 */

@interface MyUTFGridEventListener : NTUTFGridEventListener

@property NTLocalVectorDataSource *source;

@end

@interface MyCartoVisBuilder : NTCartoVisBuilder

@property NTMapView* mapView;
@property NTVectorLayer* vectorLayer;
@property NTTorqueTileLayer* torqueLayer;

@end

/*
 * Implementation
 */
@implementation BaseVisController

- (void)updateVis:(NSString *)url
{
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self.mapView getLayers] clear];
        
        // Create overlay layer for popups
        NTProjection* proj = [[self.mapView getOptions] getBaseProjection];
        NTLocalVectorDataSource* dataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
        NTVectorLayer* vectorLayer = [[NTVectorLayer alloc] initWithDataSource:dataSource];
        
        // Create VIS loader
        NTCartoVisLoader* loader = [[NTCartoVisLoader alloc] init];
        [loader setDefaultVectorLayerMode:YES];
        
        // Load fonts package
        NTBinaryData* fontsData = [NTAssetUtils loadAsset:@"carto-fonts.zip"];
        [loader setVectorTileAssetPackage:[[NTZippedAssetPackage alloc] initWithZipData:fontsData]];
        
        MyCartoVisBuilder* visBuilder = [[MyCartoVisBuilder alloc] init];
        visBuilder.vectorLayer = vectorLayer;
        visBuilder.mapView = self.mapView;

        [loader loadVis:visBuilder visURL:url];

        [[self.mapView getLayers] add:vectorLayer];
    });
}

@end

@implementation MyCartoVisBuilder

- (void)setCenter:(NTMapPos *)mapPos
{
    [self.mapView setFocusPos:[[[self.mapView getOptions] getBaseProjection] fromWgs84:mapPos] durationSeconds:1.0f];
}

- (void)setZoom:(float)zoom
{
    [self.mapView setZoom:zoom durationSeconds:1.0f];
}

- (void)addLayer:(NTLayer *)layer attributes:(NTVariant *)attributes
{
    // Add the layer to the map view
    [[self.mapView getLayers] add:layer];
    
    NTTileLayer *tileLayer = (NTTileLayer*)layer;
    
    MyUTFGridEventListener *listener = [[MyUTFGridEventListener alloc] init];
    listener.source = (NTLocalVectorDataSource *)[self.vectorLayer getDataSource];
    [tileLayer setUTFGridEventListener:listener];
    
    NTProjection *projection;
    
    NTLocalVectorDataSource *source = [[NTLocalVectorDataSource alloc]initWithProjection:projection];
    NTVectorLayer *layer_ = [[NTVectorLayer alloc]initWithDataSource:source];
    
    [[self.mapView getLayers]add:layer_];
    
    NTVectorElement *popup = [[source getAll]get:0];
    [source remove:popup];
    
    NTBalloonPopupStyleBuilder *builder = [[NTBalloonPopupStyleBuilder alloc]init];
    [builder setDescriptionWrap:NO];
    [builder setPlacementPriority:1];
    
    NSString *title = @"";
    NSString *description = @"";
    CGFloat latitude = 0;
    CGFloat longitude = 0;
    [NTMapPos alloc]ini
    NTMapPos *position = [[NTMapPos alloc]initWithX:latitude y:longitude];
    position = [projection fromWgs84:position];
    
    NTBalloonPopup *popup = [NTBalloonPopup alloc]initWithPos:position style:[builder buildStyle] title:title desc:description];
}

@end

@implementation MyUTFGridEventListener

- (BOOL)onUTFGridClicked:(NTUTFGridClickInfo *)clickInfo
{
    [self.source clear];

    NTBalloonPopupStyleBuilder *builder = [[NTBalloonPopupStyleBuilder alloc] init];
    NTBalloonPopupMargins *margins = [[NTBalloonPopupMargins alloc] initWithLeft:6 top:3 right:6 bottom:3];
    [builder setLeftMargins:margins];
    [builder setPlacementPriority:10];
    
    NSString *description = [NSString stringWithFormat:@"%@", [clickInfo getElementInfo]];
    
    NTBalloonPopup *popup = [[NTBalloonPopup alloc] initWithPos:[clickInfo getClickPos] style:[builder buildStyle] title:@"Clicked" desc:description];
    
    [self.source add:popup];
    
    return true;
}

@end
    
     
     
     
     
     
     
