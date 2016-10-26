
#import "MapSampleBaseController.h"
#import <math.h>

@interface WMSMapController : MapSampleBaseController

@end

@interface HttpWmsTileDataSource : NTHTTPTileDataSource

@property int tileSize;

@property NSString *baseUrl;
@property NSString *layer;
@property NSString *format;
@property NSString *style;

@property BOOL isWGS;

@property NTProjection *projection;

@end

@implementation WMSMapController

-(void) viewDidLoad
{
    NTProjection *projection = [[self.mapView getOptions] getBaseProjection];
    
    NSString *url = @"http://basemap.nationalmap.gov/arcgis/services/USGSTopo/MapServer/WmsServer?";
    NSString *layer = @"0";
    
    HttpWmsTileDataSource *source = [[HttpWmsTileDataSource alloc] initWithMinZoom:0 maxZoom:14 baseURL:url];
    source.baseUrl = url;
    source.tileSize = 256;
    source.layer = layer;
    source.format = @"image/png8";
    source.style = @"";
    source.isWGS = NO;
    source.projection = projection;
    
    NTRasterTileLayer *wmsLayer = [[NTRasterTileLayer alloc] initWithDataSource:source];
    
    
    double zoomLevelBias = log([[self.mapView getOptions] getDPI] / 160) / log(2);
    [wmsLayer setZoomLevelBias:zoomLevelBias];
    
    [[self.mapView getLayers] add:wmsLayer];
    
    NTMapPos *position = [[NTMapPos alloc] initWithX:-100 y:40];
    [self.mapView setFocusPos: [projection fromWgs84:position] durationSeconds:1];
    [self.mapView setZoom:5 durationSeconds:1];
}

@end

/**
 * _________________________________________________
 * Creates WMS DataSource, based on tiles.
 * Map service must support EPSG:3857 or EPSG:4326.
 *     - EPSG:3857 has full compatibility and accuracy,
 *     - many services with EPSG:4326 work also,
 *       but on low zooms (world view) it is inaccurate,
 *       because map display projection is always EPSG:3857 (in SDK 3.0)
 *
 *     Only GetMap is implemented
 *
 * * minZoom minimal zoom
 * * maxZoom max zoom for map server
 * * proj datasource projection, currently should be EPSG:3857
 * * wgsWms false - uses EPSG:3857 for server,
 *   true - uses WGS84 (EPSG:4326) which is less accurate in low zooms
 * * baseUrl You need to configure direct map URL,
 *   GetCapabilities is NOT used here
 * * style - usually empty string, comma separated
 * * layer comma-separated list of layers
 * * format e.g. image/png, image/jpeg
 * _________________________________________________
 */

@implementation HttpWmsTileDataSource

-(id) initWithMinZoom:(int)minZoom maxZoom:(int)maxZoom baseUrl: (NSString *)baseUrl
{
    self.baseUrl = baseUrl;
    self = [super initWithMinZoom:minZoom maxZoom:maxZoom baseURL:baseUrl];
    return self;
}

-(NSString *) buildTileURL:(NSString *)baseURL tile:(NTMapTile *)tile
{
    // Example Url:
    // http://basemap.nationalmap.gov/arcgis/services/USGSTopo/MapServer/WmsServer?
    // LAYERS=0&FORMAT=image%2Fpng8&SERVICE=WMS&VERSION=1.1.0&REQUEST=GetMap&STYLES=
    // &EXCEPTIONS=application%2Fvnd.ogc.se_inimage&SRS=EPSG%3A3857&WIDTH=256&HEIGHT=256
    // &BBOX=-20037508.3427892%2C0%2C0%2C20037508.3427892
    
    NSString *srs = @"EPSG:3857";
    NSString *bbox = [self getBBox:tile];
    
    NSLog(@"BASEURL:");
    NSLog(self.baseUrl);
    
    NSString *url = self.baseUrl;
    
    url = [self append:url key:@"LAYERS" value:self.layer];
    url = [self append:url key:@"FORMAT" value:self.format];
    url = [self append:url key:@"SERVICE" value:@"WMS"];
    url = [self append:url key:@"VERSION" value:@"1.1.0"];
    url = [self append:url key:@"REQUEST" value:@"GetMap"];
    url = [self append:url key:@"STYLES" value:self.style];
    url = [self append:url key:@"EXCEPTIONS" value:@"application/vnd.ogc.se_inimage"];
    url = [self append:url key:@"SRS" value:srs];
    
    NSString *size = [NSString stringWithFormat:@"%d", self.tileSize];
    url = [self append:url key:@"WIDTH" value:size];
    url = [self append:url key:@"HEIGHT" value:size];
    
    url = [self append:url key:@"BBOX" value:bbox];
    
    NSLog(@"URL: ");
    NSLog(url);
    
    return url;
}

-(NSString *) getBBox: (NTMapTile *)tile
{
    NTMapBounds *envelope = [self getTileBounds:[tile getX] ty:[tile getY] zoom:[tile getZoom] projection:self.projection];
    
    NSString *result = [@"" stringByAppendingFormat:@"%f", [[envelope getMin] getX]];
    result = [result stringByAppendingString:@","];
    result = [result stringByAppendingFormat:@"%f", [[envelope getMin] getY]];
    result = [result stringByAppendingString:@","];
    result = [result stringByAppendingFormat:@"%f", [[envelope getMax] getX]];
    result = [result stringByAppendingString:@","];
    result = [result stringByAppendingFormat:@"%f", [[envelope getMax] getY]];
    
    return result;
}

-(NTMapBounds *) getTileBounds: (int) tx ty:(int) ty zoom:(int)zoom projection:(NTProjection *)projection
{
    NTMapBounds *bounds = [projection getBounds];
    
    // World size (bounds), approx 40000km
    double boundWidth = [[bounds getMax] getX] - [[bounds getMin] getX];
    double boundHeight = [[bounds getMax] getY] - [[bounds getMin] getY];
    
    // Proportion. 1 in EPSG3857
    int xCount = MAX(1, round(boundWidth / boundHeight));
    int yCount = MAX(1, round(boundHeight / boundWidth));
    
    // Resolution
    double resx = boundWidth / xCount / (self.tileSize * (1 << zoom));
    double resy = boundHeight / yCount / (self.tileSize * (1 << zoom));
    
    double minx = (tx + 0) * self.tileSize * resx + [[bounds getMin] getX];
    double maxx = (tx + 1) * self.tileSize * resx + [[bounds getMin] getX];
    
    double miny = -(ty + 1) * self.tileSize * resy + [[bounds getMax] getY];
    double maxy = -(ty + 0) * self.tileSize * resy + [[bounds getMax] getY];
    
    NTMapPos *min = [[NTMapPos alloc] initWithX:minx y:miny];
    NTMapPos *max = [[NTMapPos alloc] initWithX:maxx y:maxy];
    
    if (self.isWGS) {
        min = [projection fromWgs84:min];
        max = [projection fromWgs84:max];
    }
    
    return [[NTMapBounds alloc] initWithMin:min max:max];
}

-(NSString *) append: (NSString *)url key:(NSString *)key value:(NSString *)value
{
    NSString *property = @"";
    
    if (![[url substringFromIndex: [url length] - 1] isEqualToString:@"?"]) {
        // Initial property will start with ?, append & for later properties
        property = [property stringByAppendingString:@"&"];
    }
    
    property = [property stringByAppendingString:key];
    property = [property stringByAppendingString:@"="];
    property = [property stringByAppendingString:value];
    property = [property stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];
    
    return [url stringByAppendingString:property];
}

@end










