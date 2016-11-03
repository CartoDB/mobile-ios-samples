#import "MapBaseController.h"

/*
 * A sample that uses bundled asset for offline base map.
 * As MBTilesDataSource can be used only with files residing in file system,
 * the assets needs to be copied first to the SDCard.
 */
@interface BundledMapController : MapBaseController

@end

@implementation BundledMapController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Get the base projection set in the base class
	NTProjection* proj = [[self.mapView getOptions] getBaseProjection];
	
	// Zoom to Rome
	[self.mapView setFocusPos:[proj fromWgs84:[[NTMapPos alloc] initWithX:12.4807 y: 41.8962]]  durationSeconds:0];
	[self.mapView setZoom:13 durationSeconds:0];
}

- (NTTileDataSource*)createTileDataSource
{
    // file-based local offline datasource
    NSString* fullpathVT = [[NSBundle mainBundle] pathForResource:@"rome_ntvt" ofType:@"mbtiles"];
    NTTileDataSource* vectorTileDataSource = [[NTMBTilesTileDataSource alloc] initWithMinZoom:0 maxZoom:14 path:fullpathVT];
    return vectorTileDataSource;
}

@end
