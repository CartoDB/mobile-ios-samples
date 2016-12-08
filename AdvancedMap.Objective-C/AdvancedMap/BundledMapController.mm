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
    
    // Remove default baselayer
    [[self.mapView getLayers] clear];
    
	// Get the base projection set in the base class
	NTProjection* projection = [[self.mapView getOptions] getBaseProjection];
	
    NTTileDataSource *source= [self createTileDataSource];

    NTBinaryData *styleAsset = [NTAssetUtils loadAsset:@"nutiteq-dark.zip"];
    NTZippedAssetPackage *package = [[NTZippedAssetPackage alloc]initWithZipData:styleAsset];
    NTCompiledStyleSet *styleSet = [[NTCompiledStyleSet alloc]initWithAssetPackage:package];
    
    NTMBVectorTileDecoder *decoder = [[NTMBVectorTileDecoder alloc]initWithCompiledStyleSet:styleSet];

    NTVectorTileLayer *layer = [[NTVectorTileLayer alloc]initWithDataSource:source decoder:decoder];
    [[self.mapView getLayers]add:layer];
    
    // Zoom to Rome
    [self.mapView setFocusPos:[projection fromWgs84:[[NTMapPos alloc] initWithX:12.4807 y: 41.8962]]  durationSeconds:0];
    [self.mapView setZoom:13 durationSeconds:0];
}

- (NTTileDataSource*)createTileDataSource
{
    NSString *name = @"rome_ntvt";
    NSString *extension = @"mbtiles";
    
    // file-based local offline datasource
    NSString* source = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *destination = [paths firstObject];
    
    if ([[NSFileManager defaultManager] isReadableFileAtPath:source]) {
        [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:nil];
    }
    
    NTTileDataSource* vectorTileDataSource = [[NTMBTilesTileDataSource alloc] initWithMinZoom:0 maxZoom:14 path:destination];
    return vectorTileDataSource;
}

@end
