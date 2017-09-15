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
    NTProjection* projection = [[self.contentView.mapView getOptions] getBaseProjection];
    NTTileDataSource *source= [self createTileDataSource];

    NTCartoOnlineVectorTileLayer *baseLayer = [[NTCartoOnlineVectorTileLayer alloc]initWithStyle:NT_CARTO_BASEMAP_STYLE_VOYAGER];
    NTVectorTileDecoder *decoder = [baseLayer getTileDecoder];
    
    NTVectorTileLayer *layer = [[NTVectorTileLayer alloc]initWithDataSource:source decoder:decoder];
    [[self.contentView.mapView getLayers] add:layer];
    
    // Zoom to Rome
    [self.contentView.mapView setFocusPos:[projection fromWgs84:[[NTMapPos alloc] initWithX:12.4807 y: 41.8962]]  durationSeconds:0];
    [self.contentView.mapView setZoom:13 durationSeconds:0];
}

- (NTTileDataSource*)createTileDataSource
{
    NSString *name = @"rome_carto-streets";
    NSString *extension = @"mbtiles";
    
    // file-based local offline datasource
    NSString* source = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    
    NTTileDataSource* vectorTileDataSource = [[NTMBTilesTileDataSource alloc] initWithMinZoom:0 maxZoom:14 path:source];
    return vectorTileDataSource;
}

@end
