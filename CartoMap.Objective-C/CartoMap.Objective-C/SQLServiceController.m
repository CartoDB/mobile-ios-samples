
#import "MapBaseController.h"

@interface SQLServiceController : MapBaseController

@property NTProjection *projection;
@property NTLocalVectorDataSource *source;

@end

@implementation SQLServiceController

-(void) viewDidLoad
{
    [self addDarkBaseLayer];
    
    // Base layer is Carto online vector tile layer in our case.
    NTCartoOnlineVectorTileLayer *baseLayer = (NTCartoOnlineVectorTileLayer *)[[self.mapView getLayers]get:0];
    
    // We can modify style parameters of our base layer's tile decoder
    // In this example, texts are removed so dots would be more prominent
    [((NTMBVectorTileDecoder *)[baseLayer getTileDecoder]) setStyleParameter:@"lang" value:@"nolang"];
    
    self.projection = [[self.mapView getOptions] getBaseProjection];
    
    // Create a datasource and layer for the map
    self.source = [[NTLocalVectorDataSource alloc]initWithProjection:self.projection];
    NTVectorLayer *layer = [[NTVectorLayer alloc] initWithDataSource:self.source];
    [[self.mapView getLayers] add:layer];
}

-(void) viewDidAppear:(BOOL)animated
{
    // Only get cities with over 100k, else it'll be too many
    NSString *sql = @"SELECT * FROM cities15000 WHERE population > 100000";
    
    // Initialize CartoSQL service, set a username
    NTCartoSQLService *service = [[NTCartoSQLService alloc] init];
    [service setUsername:@"nutiteq"];
    
    NTPointStyleBuilder *builder = [[NTPointStyleBuilder alloc]init];
    NTColor *color = [[NTColor alloc] initWithR:255 g:0 b:0 a:255];
    [builder setColor:color];
    [builder setSize:1];

    NTPointStyle *style = [builder buildStyle];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    
    // Set on background thread for "animated" point appear
    dispatch_async(queue, ^{
        NTFeatureCollection *features = [service queryFeatures:sql proj:self.projection];
    
        for (int i = 0; i < [features getFeatureCount]; i++) {
            NTPointGeometry *geometry = (NTPointGeometry *)[[features getFeature:i] getGeometry];
        
            NTPoint *point = [[NTPoint alloc] initWithGeometry:geometry style:style];
            [self.source add:point];
        }
    });
}

@end




