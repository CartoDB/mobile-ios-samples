
#import "MapBaseController.h"

@interface AnonymousVectorTableController : MapBaseController

@end

@implementation AnonymousVectorTableController

-(void) viewDidLoad
{
    // Init default vector layer
    NTCartoOnlineVectorTileLayer *layer = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_VOYAGER];
    [[self.mapView getLayers] add:layer];
    
    NTCartoMapsService* mapsService = [[NTCartoMapsService alloc] init];
    
    [mapsService setUsername:@"nutiteq"];
    
    // Use vector layers, not raster layers
    [mapsService setDefaultVectorLayerMode:TRUE];
    [mapsService setInteractive:TRUE];
    
    NTVariant* variant = [NTVariant fromString:[self getConfig]];
    NTLayerVector *layers = [mapsService buildMap:variant];
    
    for (int i = 0; i < [layers size]; i++) {
        
        NTLayer* layer = [layers get:i];
        [[self.mapView getLayers]add:layer];
    }
    
    NTProjection* projection = [[self.mapView getOptions] getBaseProjection];
    NTMapPos* newYork = [projection fromWgs84:[[NTMapPos alloc] initWithX:-74.0059 y:40.7127]];
    
    [self.mapView setFocusPos:newYork durationSeconds:0];
    [self.mapView setZoom:15 durationSeconds:1];
}

- (NSString*) getConfig
{
    NSDictionary* options = @{
                              @"sql": @"select * from stations_1",
                              @"cartocss": [self getCartoCSS],
                              @"cartocss_version": @"2.1.1",
                              @"interactivity": [self getInteractivityJson],
                              @"attributes": [self getAttributesJson]
                              };

    NSMutableArray *layerArray = [[NSMutableArray alloc]init];
    NSDictionary *layerJson = @{ @"options": options, @"type": @"cartodb" };
    
    [layerArray addObject:layerJson];
    
    NSDictionary *json = @{
                           @"version": @"1.0.1",
                           @"stat_tag": @"3c6f224a-c6ad-11e5-b17e-0e98b61680bf",
                           @"layers": layerArray
                           };
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(NSString *) getCartoCSS
{
    NSString *base = @"#stations_1 { marker-fill-opacity:0.9; marker-line-color:#FFF; marker-line-width:2; marker-line-opacity:1; marker-placement:point; marker-type:ellipse; marker-width:10; marker-allow-overlap:true; }";
    
    NSString *attributes = @"#stations_1[status = 'In Service'] { marker-fill:#0F3B82; } #stations_1[status = 'Not In Service'] { marker-fill:#aaaaaa; } #stations_1[field_9 = 200] { marker-width:80.0; } #stations_1[field_9 <= 49] { marker-width:25.0; } #stations_1[field_9 <= 38] { marker-width:22.8; } #stations_1[field_9 <= 34] { marker-width:20.6; } #stations_1[field_9 <= 29] { marker-width:18.3; } #stations_1[field_9 <= 25] { marker-width:16.1; } #stations_1[field_9 <= 20.5] { marker-width:13.9; } #stations_1[field_9 <= 16] { marker-width:11.7; } #stations_1[field_9 <= 12] { marker-width:9.4; } #stations_1[field_9 <= 8] { marker-width:7.2; } #stations_1[field_9 <= 4] { marker-width:5.0; } ";
    
    return [base stringByAppendingString:attributes];
}

-(NSMutableArray *) getInteractivityJson
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:@"cartodb_id"];
    return array;
}

-(NSDictionary *) getAttributesJson
{
    NSMutableArray *columns = [[NSMutableArray alloc]init];
    [columns addObject:@"name"];
    [columns addObject:@"field_9"];
    [columns addObject:@"slot"];
    
    return @{ @"id": @"cartodb_id", @"columns": columns };
}

@end












