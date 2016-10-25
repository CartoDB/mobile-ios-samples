#import "MapSampleBaseController.h"
#import "MyMergedRasterTileDataSource.h"

/*
 * A sample demonstrating how to create and use custom raster tile data source.
 * MyMergedRasterTileDataSource uses two input tile data sources to
 * create blended tile bitmaps. This can be faster than using two separate raster layers
 * and takes less memory.
 */
@interface CustomRasterDataSourceSampleController : MapSampleBaseController

@end

@implementation CustomRasterDataSourceSampleController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Set the base projection, that will be used for most MapView, MapEventListener and Options methods
	NTEPSG3857* proj = [[NTEPSG3857 alloc] init];
	[[self.mapView getOptions] setBaseProjection:proj];

	// Set initial location and other parameters, don't animate
    // This is San Francisco for nicer view
    [self.mapView setFocusPos:[proj fromWgs84:[[NTMapPos alloc] initWithX:-122.427521 y:37.768544]]  durationSeconds:0];
	[self.mapView setZoom:11 durationSeconds:0];
	[self.mapView setRotation:0 durationSeconds:0];
	
	// Initialize a OSM raster data source
	NTHTTPTileDataSource* baseRasterTileDataSource = [[NTHTTPTileDataSource alloc] initWithMinZoom:0 maxZoom:24 baseURL:@"http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png"];
	
    // Initialize PSM hillshading raster data source
	NTHTTPTileDataSource* hillsRasterTileDataSource = [[NTHTTPTileDataSource alloc] initWithMinZoom:0 maxZoom:24 baseURL:@"http://tiles.wmflabs.org/hillshading/{zoom}/{x}/{y}.png"];
	
    // Initialize a custom datasource that will combine those two datasources into one
	MyMergedRasterTileDataSource* mergedRasterTileDataSource = [[MyMergedRasterTileDataSource alloc] initWithDataSource1:baseRasterTileDataSource dataSource2:hillsRasterTileDataSource];
	
    // Initialize offline raster tile cache with the previous datasource and a sqlite database
	NTPersistentCacheTileDataSource* cachedRasterTileDataSource = [[NTPersistentCacheTileDataSource alloc] initWithDataSource:mergedRasterTileDataSource databasePath:[NTAssetUtils calculateWritablePath:@"cache4.db"]];
		
	// Initialize a raster layer with the previous data source
	NTRasterTileLayer* rasterLayer = [[NTRasterTileLayer alloc] initWithDataSource:cachedRasterTileDataSource];
	
	// Add the previous raster layer to the map
	[[self.mapView getLayers] add:rasterLayer];
}

@end
