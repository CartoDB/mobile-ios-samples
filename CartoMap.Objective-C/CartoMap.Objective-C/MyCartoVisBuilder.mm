

#import "MyCartoVisBuilder.h"
#import "MyUTFGridEventListener.h"

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
    
    // Check if the layer has info window. In that case will add a custom UTF grid event listener to the layer.
    NTVariant* infoWindow = [attributes getObjectElement:@"infowindow"];
    
    if ([infoWindow getType] == NT_VARIANT_TYPE_OBJECT) {
        
        MyUTFGridEventListener* myEventListener = [[MyUTFGridEventListener alloc] init];
        myEventListener.vectorLayer = self.vectorLayer;
        
        NTTileLayer* tileLayer = (NTTileLayer*)layer;
        [tileLayer setUTFGridEventListener:myEventListener];
    }
    
    // Check if torque layer, if yes, then store it
    if ([layer isKindOfClass:[NTTorqueTileLayer class]]) {
        self.torqueLayer = (NTTorqueTileLayer*)layer;
    }
}

@end
