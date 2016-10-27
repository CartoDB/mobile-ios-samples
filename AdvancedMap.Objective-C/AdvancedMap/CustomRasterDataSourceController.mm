#import "MapBaseController.h"

/*
 * A sample demonstrating how to create and use custom raster tile data source.
 * MyMergedRasterTileDataSource uses two input tile data sources to
 * create blended tile bitmaps. This can be faster than using two separate raster layers
 * and takes less memory.
 */
@interface CustomRasterDataSourceController : MapBaseController

@end

/*
 * A custom raster tile data source that loads tiles from two sources and then blends
 * them into a single tile.
 */
@interface  MergedRasterTileDataSource : NTTileDataSource

-(id)initWithDataSource1: (NTTileDataSource*)dataSource1 dataSource2: (NTTileDataSource*)dataSource2;

-(NTTileData*)loadTile: (NTMapTile*)tile;

@property (strong, nonatomic) NTTileDataSource* dataSource1;
@property (strong, nonatomic) NTTileDataSource* dataSource2;

@end

/*
 * Custom Raster Data Source Controller Implementation
 */
@implementation CustomRasterDataSourceController

static NSString* TILED_RASTER_URL = @"http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png";
static NSString* HILLSHADE_RASTER_URL = @"http://tiles.wmflabs.org/hillshading/{zoom}/{x}/{y}.png";

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    [[self.mapView getLayers]clear];
	// Set the base projection, that will be used for most MapView, MapEventListener and Options methods
	NTEPSG3857* proj = [[NTEPSG3857 alloc] init];
	[[self.mapView getOptions] setBaseProjection:proj];

	// Set initial location and other parameters, don't animate
    // This is San Francisco for nicer view
    [self.mapView setFocusPos:[proj fromWgs84:[[NTMapPos alloc] initWithX:-122.427521 y:37.768544]]  durationSeconds:0];
	[self.mapView setZoom:11 durationSeconds:0];
	[self.mapView setRotation:0 durationSeconds:0];
	
	// Initialize a OSM raster data source
	NTHTTPTileDataSource* baseRasterTileDataSource = [[NTHTTPTileDataSource alloc] initWithMinZoom:0 maxZoom:24 baseURL:TILED_RASTER_URL];
	
    // Initialize PSM hillshading raster data source
	NTHTTPTileDataSource* hillsRasterTileDataSource = [[NTHTTPTileDataSource alloc] initWithMinZoom:0 maxZoom:24 baseURL:HILLSHADE_RASTER_URL];
	
    // Initialize a custom datasource that will combine those two datasources into one
	MergedRasterTileDataSource* mergedRasterTileDataSource = [[MergedRasterTileDataSource alloc] initWithDataSource1:baseRasterTileDataSource dataSource2:hillsRasterTileDataSource];
	
    // Initialize offline raster tile cache with the previous datasource and a sqlite database
	NTPersistentCacheTileDataSource* cachedRasterTileDataSource = [[NTPersistentCacheTileDataSource alloc] initWithDataSource:mergedRasterTileDataSource databasePath:[NTAssetUtils calculateWritablePath:@"cache4.db"]];
		
	// Initialize a raster layer with the previous data source
	NTRasterTileLayer* rasterLayer = [[NTRasterTileLayer alloc] initWithDataSource:cachedRasterTileDataSource];
	
	// Add the previous raster layer to the map
	[[self.mapView getLayers] add:rasterLayer];
}

@end

/*
 * Merged Raster Data Source Implementation
 */
@implementation MergedRasterTileDataSource

-(id)initWithDataSource1: (NTTileDataSource*)dataSource1 dataSource2: (NTTileDataSource*)dataSource2
{
    self = [super initWithMinZoom:MIN([dataSource1 getMinZoom], [dataSource2 getMinZoom])
                          maxZoom:MAX([dataSource1 getMaxZoom], [dataSource2 getMaxZoom])];
    if (self != nil) {
        _dataSource1 = dataSource1;
        _dataSource2 = dataSource2;
    }
    return self;
}

-(NTTileData *)loadTile: (NTMapTile*)tile
{
    NTTileData* tileData1 = [_dataSource1 loadTile:tile];
    NTTileData* tileData2 = [_dataSource2 loadTile:tile];
    if (!tileData1) {
        return tileData2;
    }
    
    if (!tileData2) {
        return tileData1;
    }
    
    // Create bitmaps
    NTBitmap* tileBitmap1 = [NTBitmap createFromCompressed: tileData1.getData];
    NTBitmap* tileBitmap2 = [NTBitmap createFromCompressed: tileData2.getData];
    
    // Combine the bitmaps
    UIImage* image1 = [NTBitmapUtils createUIImageFromBitmap: tileBitmap1];
    UIImage* image2 = [NTBitmapUtils createUIImageFromBitmap: tileBitmap2];
    
    CGSize imageSize = CGSizeMake(CGImageGetWidth(image1.CGImage), CGImageGetHeight(image2.CGImage));
    
    UIGraphicsBeginImageContext(imageSize);
    
    [image1 drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    [image2 drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    
    // Extract image
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NTBitmap* tileBitmap = [NTBitmapUtils createBitmapFromUIImage:image];
    
    return [[NTTileData alloc] initWithData: tileBitmap.compressToInternal];
}

@end












