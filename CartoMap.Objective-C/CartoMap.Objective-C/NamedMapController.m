
#import "VectorMapBaseController.h"

@interface NamedMapController : VectorMapBaseController

@property NTVectorLayer* vectorLayer;

@end

@interface VectorTileEventListener : NTVectorTileEventListener

@property NTVectorLayer* vectorLayer;

@end

@implementation NamedMapController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    NTCartoMapsService* mapsService = [[NTCartoMapsService alloc] init];
    
    [mapsService setUsername:@"demo-admin"];
    
    // on-premises server connect
    [mapsService setAPITemplate:@"http://192.168.1.31/user/{user}"];
    
    // Use raster layers, not vector layers
    [mapsService setDefaultVectorLayerMode:YES];
    
    NTLayerVector *layers = [mapsService buildNamedMap:@"tpl_708edf80_8bf0_11e6_806c_0e2b00211e61" templateParams: [[NTStringVariantMap alloc] init]];
    
    for (int i = 0; i < [layers size]; i++) {
        
        NTLayer* layer = [layers get:i];
       // [[self.mapView getLayers]add:layer];
    }
    
    NTHTTPTileDataSource* datasourceOver = [[NTHTTPTileDataSource alloc] initWithMinZoom:0 maxZoom:13 baseURL:@"http://192.168.1.31/user/demo-admin/api/v1/map/demo-admin@05be0b35@d299d92a84985240af8767694f134620:1476098385738/1/{z}/{x}/{y}.mvt"];
    
    
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
    
    VectorTileEventListener* myEventListener = [[VectorTileEventListener alloc] init];
    myEventListener.vectorLayer = self.vectorLayer;
    [layerOver setVectorTileEventListener:myEventListener];
    
}
@end

@implementation VectorTileEventListener

- (BOOL)onVectorTileClicked:(NTVectorTileClickInfo *)clickInfo
{
    NTLocalVectorDataSource* dataSource = (NTLocalVectorDataSource*)[self.vectorLayer getDataSource];
    [dataSource clear];
    
    // Build overlay vector element
    NTFeature* feature = [clickInfo getFeature];
    NTGeometry* geom = [feature getGeometry];
    
    NTColor* color = [[NTColor alloc] initWithR:0 g:100 b:200 a:150];
    
    NTPointStyleBuilder* pointStyleBuilder = [[NTPointStyleBuilder alloc] init];
    [pointStyleBuilder setColor: color];
    
    NTLineStyleBuilder* lineStyleBuilder = [[NTLineStyleBuilder alloc] init];
    [lineStyleBuilder setColor: color];
    
    NTPolygonStyleBuilder* polygonStyleBuilder = [[NTPolygonStyleBuilder alloc] init];
    [polygonStyleBuilder setColor: color];
    
    if ([geom isKindOfClass:[NTPointGeometry class]]) {
        [dataSource add: [[NTPoint alloc] initWithGeometry:(NTPointGeometry*)geom style:[pointStyleBuilder buildStyle]]];
    }
    if ([geom isKindOfClass:[NTLineGeometry class]]) {
        [dataSource add: [[NTLine alloc] initWithGeometry:(NTLineGeometry*)geom style:[lineStyleBuilder buildStyle]]];
    }
    if ([geom isKindOfClass:[NTPolygonGeometry class]]) {
        [dataSource add: [[NTPolygon alloc] initWithGeometry:(NTPolygonGeometry*)geom style:[polygonStyleBuilder buildStyle]]];
    }
    if ([geom isKindOfClass:[NTMultiGeometry class]]) {
        NTGeometryCollectionStyleBuilder* geomCollectionStyleBuilder = [[NTGeometryCollectionStyleBuilder alloc] init];
        [geomCollectionStyleBuilder setPointStyle:[pointStyleBuilder buildStyle]];
        [geomCollectionStyleBuilder setLineStyle:[lineStyleBuilder buildStyle]];
        [geomCollectionStyleBuilder setPolygonStyle:[polygonStyleBuilder buildStyle]];
        [dataSource add: [[NTGeometryCollection alloc] initWithGeometry:(NTMultiGeometry*)geom style:[geomCollectionStyleBuilder buildStyle]]];
    }
    
    // Add balloon popup to the click position
    NTBalloonPopup* clickPopup = [[NTBalloonPopup alloc] init];
    NTBalloonPopupStyleBuilder* styleBuilder = [[NTBalloonPopupStyleBuilder alloc] init];
    [styleBuilder setPlacementPriority:10];
    NSString* clickMsg = [[feature getProperties] description];
    clickPopup = [[NTBalloonPopup alloc] initWithPos:[clickInfo getClickPos]
                                               style:[styleBuilder buildStyle]
                                               title:@"Clicked"
                                                desc:clickMsg];
    [dataSource add:clickPopup];
    
    // if returns YES then no extra events. If NO then can be called again for next elements.
    // use mapListener.onMapClicked() event to know that all other events are finished
    
    return YES;
}

@end







