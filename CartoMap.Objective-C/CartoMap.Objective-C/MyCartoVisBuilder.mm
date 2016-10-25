

#import "MyCartoVisBuilder.h"
#import "MyVectorTileListener.h"

@implementation MyCartoVisBuilder

-(void)setDescription:(NTVariant *)descriptionInfo
{
    NSLog(@"%@",[descriptionInfo description]);
}

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
    
    
    if ([layer isKindOfClass:[NTVectorTileLayer class]]) {
        
        // add listener for vector tile clicks
        NTVectorTileLayer* tileLayer = (NTVectorTileLayer*)layer;
        [tileLayer setUTFGridDataSource: nil]; // usually do not use this.
        
        MyVectorTileListener* myEventListener = [[MyVectorTileListener alloc] init];
        myEventListener.vectorLayer = self.vectorLayer;
        [tileLayer setVectorTileEventListener:myEventListener];
    }
    
    
    // Check if torque layer, if yes, then store it
    if ([layer isKindOfClass:[NTTorqueTileLayer class]]) {
        self.torqueLayer = (NTTorqueTileLayer*)layer;
    }
}

@end
