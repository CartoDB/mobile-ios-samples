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
   // [[self.mapView getLayers] clear];
    
    
	// Get the base projection set in the base class
	NTProjection* projection = [[self.mapView getOptions] getBaseProjection];
	
    NTTileDataSource *source= [self createTileDataSource];

    NTBinaryData *styleAsset = [NTAssetUtils loadAsset:@"nutiteq-dark.zip"];
    NTZippedAssetPackage *package = [[NTZippedAssetPackage alloc]initWithZipData:styleAsset];
    NTCompiledStyleSet *styleSet = [[NTCompiledStyleSet alloc]initWithAssetPackage:package];
    
//    NTMBVectorTileDecoder *decoder = [[NTMBVectorTileDecoder alloc]initWithCompiledStyleSet:styleSet];

    NTCartoCSSStyleSet* stylesheet = [[NTCartoCSSStyleSet alloc]initWithCartoCSS:@"#agri_landsuit_rice_th_all_suit_iusegeojson{ line-color: #FFFFFF; line-width: 0; } #agri_landsuit_rice_th_all_suit_iusegeojson[suit_type='S1'] { polygon-fill: #269B00; polygon-opacity: 0.5; } #agri_landsuit_rice_th_all_suit_iusegeojson[suit_type='S2'] { polygon-fill: #FFFF00; polygon-opacity: 0.5; }"];
    
    NTMBVectorTileDecoder *decoder = [[NTMBVectorTileDecoder alloc]initWithCartoCSSStyleSet:stylesheet];
    
    NTVectorTileLayer *layer = [[NTVectorTileLayer alloc]initWithDataSource:source decoder:decoder];
    [[self.mapView getLayers]add:layer];
    
    // Zoom to Rome
    [self.mapView setFocusPos:[projection fromWgs84:[[NTMapPos alloc] initWithX:12.4807 y: 41.8962]]  durationSeconds:0];
    [self.mapView setZoom:13 durationSeconds:0];
    
    NTMapPos* position = [projection fromLat:8.11065195 lng:99.89845797];
    [self.mapView setFocusPos:position durationSeconds:0];
    [self.mapView setZoom:11 durationSeconds:0];
    
}

- (NTTileDataSource*)createTileDataSource
{
    NSString *name = @"agri_landsuit_rice_th_all_suit_iuse";
    NSString *extension = @"mbtiles";
    
    // file-based local offline datasource
    NSString* source = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    
    NTTileDataSource* vectorTileDataSource = [[NTMBTilesTileDataSource alloc] initWithMinZoom:0 maxZoom:14 path:source];
    return vectorTileDataSource;
}

@end
