
#import "MapBaseController.h"

@interface NamedMapController : MapBaseController

@property NTVectorLayer* vectorLayer;

@end


@implementation NamedMapController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
/*
    NTCartoMapsService* mapsService = [[NTCartoMapsService alloc] init];
    
    [mapsService setUsername:@"demo-admin"];
    
    // on-premises server connect
    [mapsService setAPITemplate:@"http://192.168.56.101/user/{user}"];
    
    // Use raster layers, not vector layers
    [mapsService setDefaultVectorLayerMode:YES];
    
    NTLayerVector *layers = [mapsService buildNamedMap:@"tpl_92996e76_905d_11e6_95e0_b6c543fbf78e" templateParams: [[NTStringVariantMap alloc] init]];
    
    for (int i = 0; i < [layers size]; i++) {
        
        NTLayer* layer = [layers get:i];
        [[self.mapView getLayers]add:layer];
    }
 */
    NTHTTPTileDataSource* datasourceOver = [[NTHTTPTileDataSource alloc] initWithMinZoom:0 maxZoom:12 baseURL:@"http://192.168.56.101/user/demo-admin/api/v1/map/demo-admin@2e204cd6@24655f7ea3de1e937ecf03750a4779a8:1476263452293/1/{z}/{x}/{y}.mvt"];
    
    
    // Load fonts package
    NTBinaryData* fontsData = [NTAssetUtils loadAsset:@"carto-fonts.zip"];
    NTZippedAssetPackage* fontsAssetPackage = [[NTZippedAssetPackage alloc] initWithZipData:fontsData];
    
// Load CSS
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cartocss" ofType:@"css"];
    NSString *css = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    css = [css stringByReplacingOccurrencesOfString:@"geonames" withString:@"layer0"];

    NTCartoCSSStyleSet* stylesheet = [[NTCartoCSSStyleSet alloc]initWithCartoCSS:css assetPackage:fontsAssetPackage];
    
    
    NTMBVectorTileDecoder* decoder = [[NTMBVectorTileDecoder alloc]initWithCartoCSSStyleSet:stylesheet];
    
    NTVectorTileLayer* layerOver = [[NTVectorTileLayer alloc] initWithDataSource:datasourceOver decoder: decoder];
    [[self.mapView getLayers]add:layerOver];
    
    
    NTProjection* projection = [[self.mapView getOptions] getBaseProjection];
    NTMapPos* hiiumaa = [projection fromWgs84:[[NTMapPos alloc] initWithX:22.7478235498916 y:58.8330577553785]];
    
    [self.mapView setFocusPos:hiiumaa durationSeconds:0];
    [self.mapView setZoom:5 durationSeconds:1];
    
    // Add overlay layer, if not yet added
    if (!self.vectorLayer) {
        NTProjection* proj = [[self.mapView getOptions] getBaseProjection];
        NTLocalVectorDataSource* vectorDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
        self.vectorLayer = [[NTVectorLayer alloc] initWithDataSource:vectorDataSource];
        [[self.mapView getLayers] add:self.vectorLayer];
    }
}

@end








