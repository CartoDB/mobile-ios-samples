
#import "MapBaseController.h"

@interface NamedMapController : MapBaseController

@property NTVectorLayer* vectorLayer;

@end


@implementation NamedMapController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NTCartoMapsService* mapsService = [[NTCartoMapsService alloc] init];
    
    [mapsService setUsername:@"nutiteq"];
    
    // Use raster layers, not vector layers
    [mapsService setDefaultVectorLayerMode:YES];
    
    NTLayerVector *layers = [mapsService buildNamedMap:@"tpl_69f3eebe_33b6_11e6_8634_0e5db1731f59" templateParams: [[NTStringVariantMap alloc] init]];
    
    [[self.mapView getLayers] addAll:layers];
    
    // Coordinates are available in the viz.json we download
    NTProjection* projection = [[self.mapView getOptions] getBaseProjection];
    NTMapPos* position = [projection fromLat:37.32549682016584 lng:-121.94595158100128];
    [self.mapView setFocusPos:position durationSeconds:0];
    [self.mapView setZoom:18 durationSeconds:1];
}

@end








