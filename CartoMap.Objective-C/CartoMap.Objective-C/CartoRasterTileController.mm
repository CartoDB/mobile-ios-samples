
#import "VectorMapBaseController.h"

@interface CartoRasterTileController : VectorMapBaseController

- (NSString*)getConfig;

@property NSString* sql;
@property NSString* cartoCSS;

@end

@implementation CartoRasterTileController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sql = @"select * from table_46g";
    self.cartoCSS = @"#table_46g {raster-opacity: 0.5;}";
    
    NTCartoMapsService* mapsService = [[NTCartoMapsService alloc] init];
    
    [mapsService setUsername:@"nutiteq"];
    
    // Use raster layers, not vector layers
    [mapsService setDefaultVectorLayerMode:NO];
    
    NTVariant* variant = [NTVariant fromString:[self getConfig]];
    NTLayerVector *layers = [mapsService buildMap:variant];
    
    for (int i = 0; i < [layers size]; i++) {
        
        NTLayer* layer = [layers get:i];
        [[self.mapView getLayers]add:layer];
    }
    
    NTProjection* projection = [[self.mapView getOptions] getBaseProjection];
    NTMapPos* hiiumaa = [projection fromWgs84:[[NTMapPos alloc] initWithX:22.7478235498916 y:58.8330577553785]];
    
    [self.mapView setFocusPos:hiiumaa durationSeconds:0];
    [self.mapView setZoom:11 durationSeconds:1];
}

- (NSString*) getConfig
{
    NSDictionary* options = @{
                              @"sql": self.sql,
                              @"cartocss": self.cartoCSS,
                              @"cartocss_version": @"2.3.0",
                              @"geom_column": @"the_raster_webmercator",
                              @"geom_type": @"raster",
                              };
    
    NSMutableArray* layersArray = [[NSMutableArray alloc]init];
    NSDictionary* layers = @{
                            @"options": options,
                            @"type": @"cartodb"
                            };
    
//    [layersArray addObject:@{ @"options": options }];
//    [layersArray addObject:@{ @"type": @"cartodb" }];
    
    [layersArray addObject:layers];
    
    NSDictionary* json = @{
                           @"layers": layersArray,
                           @"version": @"1.2.0"
                           };
    NSError *error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end