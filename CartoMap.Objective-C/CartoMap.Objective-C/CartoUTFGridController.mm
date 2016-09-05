
#import "VectorMapBaseController.h"
#import "MyUTFGridEventListener.h"

@interface CartoUTFGridController : VectorMapBaseController

- (NSString*)getJsonString;

@end

@implementation CartoUTFGridController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(self.getJsonString);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NTCartoMapsService* service = [[NTCartoMapsService alloc]init];
        [service setUsername:@"nutiteq"];
        [service setDefaultVectorLayerMode:YES];
        
        NTVariant* variant = [NTVariant fromString:self.getJsonString];
        NTLayerVector* layers = [service buildMap:variant];
        
        NTProjection* projection = [[self.mapView getOptions]getBaseProjection];
        NTLocalVectorDataSource* source = [[NTLocalVectorDataSource alloc]initWithProjection:projection];
        
        for (int i = 0; i < layers.size; i++) {
            
            NTTileLayer* layer = (NTTileLayer*)[layers get:i];
            
            MyUTFGridEventListener* listener = [[MyUTFGridEventListener alloc]init];
            listener.source = source;
            
            [[self.mapView getLayers]add:layer];
        }
    });
    
    NTMapPos* position = [[NTMapPos alloc]initWithX:-74.0059 y:40.7127];
    NTMapPos* newYork = [[[self.mapView getOptions]getBaseProjection] fromWgs84: position];
    
    [self.mapView setFocusPos:newYork durationSeconds:1];
    [self.mapView setZoom:15 durationSeconds:1];
}


- (NSString*)getJsonString
{
    NSString* css = @"#stations_1{marker-fill-opacity:0.9;marker-line-color:#FFF;marker-line-width:2;marker-line-opacity:1;marker-placement:point;marker-type:ellipse;marker-width:10;marker-allow-overlap:true;}\n#stations_1[status = 'In Service']{marker-fill:#0F3B82;}\n#stations_1[status = 'Not In Service']{marker-fill:#aaaaaa;}\n#stations_1[field_9 = 200]{marker-width:80.0;}\n#stations_1[field_9 <= 49]{marker-width:25.0;}\n#stations_1[field_9 <= 38]{marker-width:22.8;}\n#stations_1[field_9 <= 34]{marker-width:20.6;}\n#stations_1[field_9 <= 29]{marker-width:18.3;}\n#stations_1[field_9 <= 25]{marker-width:16.1;}\n#stations_1[field_9 <= 20.5]{marker-width:13.9;}\n#stations_1[field_9 <= 16]{marker-width:11.7;}\n#stations_1[field_9 <= 12]{marker-width:9.4;}\n#stations_1[field_9 <= 8]{marker-width:7.2;}\n#stations_1[field_9 <= 4]{marker-width:5.0;}";
    
    NSMutableArray* interactivity = [[NSMutableArray alloc]init];
    [interactivity addObject:@"cartodb_id"];
    
    NSMutableArray* columns = [[NSMutableArray alloc]init];
    [columns addObject:@"name"];
    [columns addObject:@"field_9"];
    [columns addObject:@"slot"];
    
    NSDictionary* attributeJson = @{ @"id": @"cartodb_id", @"columns": columns };
    
    NSDictionary* optionJson = @{
                                 @"sql": @"select * from stations_1",
                                 @"cartocss": css,
                                 @"cartocss_version": @"2.1.1",
                                 @"interactivity": interactivity,
                                 @"attributes": attributeJson
                                 };
    
    NSDictionary* layerJson = @{ @"type": @"cartodb", @"options": optionJson };

    NSMutableArray* layers = [[NSMutableArray alloc]init];
//    [layers addObject:@"cartodb_id"];
    [layers addObject:layerJson];
    
    NSDictionary* final = @{
                           @"version": @"1.0.1",
                           @"stat_tag": @"3c6f224a-c6ad-11e5-b17e-0e98b61680bf",
                           @"layers": layers
                        };
    
    NSError *error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:final options:0 error:&error];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end







