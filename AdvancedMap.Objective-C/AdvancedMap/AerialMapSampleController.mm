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
    // DigitalGlobe: http://api.tiles.mapbox.com/v4/digitalglobe.nal0g75k/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZGlnaXRhbGdsb2JlIiwiYSI6ImNpcGg5dHkzYTAxM290bG1kemJraHU5bmoifQ.CHhq1DFgZPSQQC-DYWpzaQ
    // HERE: https://2.maps.nlp.nokia.com/maptile/2.1/maptile/newest/satellite.day/{z}/{x}/{y}/256/jpg?lg=eng&token=A7tBPacePg9Mj_zghvKt9Q&app_id=KuYppsdXZznpffJsKT24
	NTHTTPTileDataSource* baseRasterTileDataSource = [[NTHTTPTileDataSource alloc] initWithMinZoom:1 maxZoom:18 baseURL:@"https://2.maps.nlp.nokia.com/maptile/2.1/maptile/newest/satellite.day/{z}/{x}/{y}/256/jpg?lg=eng&token=A7tBPacePg9Mj_zghvKt9Q&app_id=KuYppsdXZznpffJsKT24"];

	// Initialize a raster layer with the previous data source
	NTRasterTileLayer* rasterLayer = [[NTRasterTileLayer alloc] initWithDataSource:baseRasterTileDataSource];
	//[rasterLayer setPreloading:NO];

    // Add the previous raster layer to the map
	[[self.mapView getLayers] add:rasterLayer];
}

@end
