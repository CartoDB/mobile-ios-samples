#import "VectorMapSampleBaseController.h"

/*
 * A sample overlay of raster hillshading, and topographic datasource with elevation contours
 */
@interface HillshadeSampleController : VectorMapSampleBaseController

@end

@implementation HillshadeSampleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the base projection, that will be used for most MapView, MapEventListener and Options methods
    NTEPSG3857* proj = [[NTEPSG3857 alloc] init];
    [[self.mapView getOptions] setBaseProjection:proj];
    
    // Set initial location and other parameters, don't animate
    // Mont Blanc, France
    [self.mapView setFocusPos:[proj fromWgs84:[[NTMapPos alloc] initWithX:6.86480 y:45.83255]]  durationSeconds:0];
    [self.mapView setZoom:15 durationSeconds:0];
    [self.mapView setRotation:0 durationSeconds:0];
    
    
    // add hills
    NTHTTPTileDataSource* hillsRasterTileDataSource = [[NTHTTPTileDataSource alloc] initWithMinZoom:0 maxZoom:24 baseURL:@"http://tiles.wmflabs.org/hillshading/{zoom}/{x}/{y}.png"];
    
    // Initialize a raster layer with the previous data source
    NTRasterTileLayer* rasterHillLayer = [[NTRasterTileLayer alloc] initWithDataSource:hillsRasterTileDataSource];
    //[rasterLayer setPreloading:NO];
    // Add the previous raster layer to the map
    [[self.mapView getLayers] add:rasterHillLayer];
}

- (NTTileDataSource*)createTileDataSource
{
    // Create global online vector tile data source, with contour data
    NTTileDataSource *vectorTileDataSource = [[NTCartoOnlineTileDataSource alloc] initWithSource:@"nutiteq.osm"];
    return vectorTileDataSource;
}

@end
