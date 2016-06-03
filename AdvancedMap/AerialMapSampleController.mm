#import "MapSampleBaseController.h"

/*
 * A sample demonstrating how to use raster layers with external tile data sources.
 */
@interface AerialMapSampleController : MapSampleBaseController

@end

@implementation AerialMapSampleController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Set the base projection, that will be used for most MapView, MapEventListener and Options methods
	NTEPSG3857* proj = [[NTEPSG3857 alloc] init];
	[[self.mapView getOptions] setBaseProjection:proj];
	
	// Set initial location and other parameters, don't animate
	[self.mapView setFocusPos:[proj fromWgs84:[[NTMapPos alloc] initWithX:24.650415 y:59.428773]]  durationSeconds:0];
	[self.mapView setZoom:5 durationSeconds:0];
	[self.mapView setRotation:0 durationSeconds:0];
	
	// Initialize a Bing raster data source
	NTHTTPTileDataSource* baseRasterTileDataSource = [[NTHTTPTileDataSource alloc] initWithMinZoom:1 maxZoom:19 baseURL:@"http://ecn.t3.tiles.virtualearth.net/tiles/a{quadkey}.jpeg?g=471&mkt=en-US"];

	// Initialize a raster layer with the previous data source
	NTRasterTileLayer* rasterLayer = [[NTRasterTileLayer alloc] initWithDataSource:baseRasterTileDataSource];
	//[rasterLayer setPreloading:NO];
	// Add the previous raster layer to the map
	[[self.mapView getLayers] add:rasterLayer];
}

@end
