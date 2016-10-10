
#import "VectorMapBaseController.h"

@interface NamedMapController : VectorMapBaseController

@end

@implementation NamedMapController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    NTCartoMapsService* mapsService = [[NTCartoMapsService alloc] init];
    
    [mapsService setUsername:@"demo-admin"];
    
    // on-premises server connect
    [mapsService setAPITemplate:@"http://192.168.1.31/user/{user}"];
    
    // Use raster layers, not vector layers
    [mapsService setDefaultVectorLayerMode:YES];
    
    NTLayerVector *layers = [mapsService buildNamedMap:@"tpl_708edf80_8bf0_11e6_806c_0e2b00211e61" templateParams: [[NTStringVariantMap alloc] init]];
    
    for (int i = 0; i < [layers size]; i++) {
        
        NTLayer* layer = [layers get:i];
        [[self.mapView getLayers]add:layer];
    }
    
    NTProjection* projection = [[self.mapView getOptions] getBaseProjection];
    NTMapPos* hiiumaa = [projection fromWgs84:[[NTMapPos alloc] initWithX:22.7478235498916 y:58.8330577553785]];
    
    [self.mapView setFocusPos:hiiumaa durationSeconds:0];
    [self.mapView setZoom:5 durationSeconds:1];
}
@end







