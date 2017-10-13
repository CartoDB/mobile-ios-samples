
#import "BaseVisController.h"

/*
 * A sample demonstrating how to use high-level Carto VisJSON API.
 * A list of different visjson URLs can be selected from the menu.
 * CartoVisLoader class is used to load and configure all corresponding layers.
 */

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
    NTMapPos *position = [[[self.mapView getOptions] getBaseProjection] fromWgs84:mapPos];
    [self.mapView setFocusPos:position durationSeconds:1.0f];
}

- (void)setZoom:(float)zoom
{
    [self.mapView setZoom:zoom durationSeconds:1.0f];
}

- (void)addLayer:(NTLayer *)layer attributes:(NTVariant *)attributes
{
    // Add the layer to the map view
    [[self.mapView getLayers] add:layer];
}

@end

     
     
     
     
     
     
