
#import "MapBaseController.h"

@interface TorqueShipController : MapBaseController

@property NTTorqueTileDecoder* decoder;
@property NTTorqueTileLayer* tileLayer;

@property NSTimer* timer;

@end

@implementation TorqueShipController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    [self addGrayBaseLayer];
    
    NSString* query = [self getQuery];
    
    // TODO FIX
    query = @"WITH%20par%20AS%20(%20%20SELECT%20CDB_XYZ_Resolution({zoom})*1%20as%20res%2C%20%20256%2F1%20as%20tile_size%2C%20CDB_XYZ_Extent({x}%2C%20{y}%2C%20{zoom})%20as%20ext%20)%2Ccte%20AS%20(%20%20%20SELECT%20ST_SnapToGrid(i.the_geom_webmercator%2C%20p.res)%20g%2C%20count(cartodb_id)%20c%2C%20floor((date_part(%27epoch%27%2C%20date)%20-%20-1796072400)%2F476536.5)%20d%20%20FROM%20(select%20*%20from%20ow)%20i%2C%20par%20p%20%20%20WHERE%20i.the_geom_webmercator%20%26%26%20p.ext%20%20%20GROUP%20BY%20g%2C%20d)%20SELECT%20(st_x(g)-st_xmin(p.ext))%2Fp.res%20x__uint8%2C%20%20%20%20%20%20%20%20(st_y(g)-st_ymin(p.ext))%2Fp.res%20y__uint8%2C%20array_agg(c)%20vals__uint8%2C%20array_agg(d)%20dates__uint16%20FROM%20cte%2C%20par%20p%20where%20(st_y(g)-st_ymin(p.ext))%2Fp.res%20%3C%20tile_size%20and%20(st_x(g)-st_xmin(p.ext))%2Fp.res%20%3C%20tile_size%20GROUP%20BY%20x__uint8%2C%20y__uint8&last_updated=1970-01-01T00%3A00%3A00.000Z";

    NSString* url = @"http://viz2.cartodb.com/api/v2/sql?q=";
    url = [url stringByAppendingString:query];
    url = [url stringByAppendingString:@"&cache_policy=persist"];

    NSString* css = [self getCSS];
    
    NTHTTPTileDataSource* source = [[NTHTTPTileDataSource alloc]initWithMinZoom:0 maxZoom:14 baseURL:url];
    
    NTCartoCSSStyleSet* stylesheet = [[NTCartoCSSStyleSet alloc]initWithCartoCSS:css];
    
    self.decoder = [[NTTorqueTileDecoder alloc]initWithStyleSet:stylesheet];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask,YES);
    NSString* supportDir = [paths objectAtIndex: 0];
    
    NSString* cacheFile = [supportDir stringByAppendingString:@"/torque_tile_cache.db"];
    
    NTTileDataSource* cacheSource = [[NTPersistentCacheTileDataSource alloc]
                                     initWithDataSource:source databasePath:cacheFile];

    self.tileLayer = [[NTTorqueTileLayer alloc]initWithDataSource:cacheSource decoder:self.decoder];
    
    // Lower priority so it would load the base layer first
    [self.tileLayer setUpdatePriority:-1];
    
    [[self.mapView getLayers] add:_tileLayer];
    [self.mapView setZoom:1 durationSeconds:0];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTorque:) userInfo:nil repeats:YES];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}

-(void) updateTorque:(NSTimer*)timer
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int frame = ([self.tileLayer getFrameNr] + 1) % [self.decoder getFrameCount];

        [self.tileLayer setFrameNr:frame];
        
    });
}

// Magic query to create torque tiles
-(NSString*) getQuery
{
    NSString* query = @"WITH par AS (SELECT Cdb_xyz_resolution({zoom}) * 1   AS res,256 / 1 AS tile_size,Cdb_xyz_extent({x}, {y}, {zoom}) AS ext),cteAS (SELECT St_snaptogrid(i.the_geom_webmercator, p.res) g, Count(cartodb_id) c, Floor(( Date_part('epoch', date) - -1796072400 ) / 476536.5) d FROM (SELECT * FROM ow) i,  par p WHERE i.the_geom_webmercator && p.ext GROUP BY g, d)SELECT ( St_x(g) - St_xmin(p.ext) ) / p.res x__uint8, ( St_y(g) - St_ymin(p.ext) ) / p.res y__uint8, Array_agg(c) vals__uint8, Array_agg(d) dates__uint16 FROM cte,  par pWHERE  ( St_y(g) - St_ymin(p.ext) ) / p.res < tile_size AND ( St_x(g) - St_xmin(p.ext) ) / p.res < tile_size GROUP BY x__uint8, y__uint8 ";
    
    // Encoding
    query = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    // Additional encoding/decoding
    query = [query stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
    query = [query stringByReplacingOccurrencesOfString:@"(" withString:@"%28"];
    query = [query stringByReplacingOccurrencesOfString:@")" withString:@"%29"];
    query = [query stringByReplacingOccurrencesOfString:@"," withString:@"%2c"];
    query = [query stringByReplacingOccurrencesOfString:@"/" withString:@"%2f"];
    query = [query stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
    query = [query stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    
    return query;
}


-(NSString*) getCSS
{
    return @"#layer {\ncomp-op: lighten;\nmarker-type:ellipse;\nmarker-width: 10;\nmarker-fill: #FEE391;\n[value > 2] { marker-fill: #FEC44F; }\n[value > 3] { marker-fill: #FE9929; }\n[value > 4] { marker-fill: #EC7014; }\n[value > 5] { marker-fill: #CC4C02; }\n[value > 6] { marker-fill: #993404; }\n[value > 7] { marker-fill: #662506; }\n\n[frame-offset = 1] {\nmarker-width: 20;\nmarker-fill-opacity: 0.1;\n}\n[frame-offset = 2] {\nmarker-width: 30;\nmarker-fill-opacity: 0.05;\n}\n}\n";
}

@end






