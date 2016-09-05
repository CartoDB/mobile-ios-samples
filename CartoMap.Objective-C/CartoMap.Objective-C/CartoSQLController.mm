
#import "VectorMapBaseController.h"
#import "MyMapEventListener.h"

@interface CartoSQLController : VectorMapBaseController

@property NSString* baseUrl;
@property NSString* query;

@end

@interface CartoDBSQLDataSource : NTVectorDataSource

@property NSString* baseUrl;
@property NSString* query;

@property NTStyle* style;

@end

@implementation CartoSQLController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.baseUrl = @"https://nutiteq.cartodb.com/api/v2/sql";
    self.query = @"SELECT cartodb_id,the_geom_webmercator AS the_geom,name,address,bikes,slot,field_8,field_9,field_16,field_17,field_18 FROM stations_1 WHERE !bbox!";
    
    NTPointStyleBuilder* builder = [[NTPointStyleBuilder alloc] init];
    [builder setColor:[[NTColor alloc]initWithR:0 g:0 b:255 a:255]];
    
    NTProjection* projection = [[self.mapView getOptions]getBaseProjection];
    
    // Initialize a local vector data source
    CartoDBSQLDataSource* source = [[CartoDBSQLDataSource alloc]initWithProjection:projection];
    source.baseUrl = self.baseUrl;
    source.query = self.query;
    source.style = [builder buildStyle];
    
    // Initialize a vector layer with the previous data source
    NTVectorLayer* layer = [[NTVectorLayer alloc]initWithDataSource:source];
    
    // Add the previous vector layer to the map
    [[self.mapView getLayers]add:layer];
    
    // Set visible zoom range for the vector layer
    NTMapRange* range = [[NTMapRange alloc]initWithMin:14 max:23];
    [layer setVisibleZoomRange:range];
    
    // Initialize a local vector data source and layer for click Balloons
    NTLocalVectorDataSource* vectorSource = [[NTLocalVectorDataSource alloc]initWithProjection:projection];
    
    // Initialize a vector layer with the previous data source
    NTVectorLayer* layer2 = [[NTVectorLayer alloc]initWithDataSource:vectorSource];
    
    // Add the previous vector layer to the map
    [[self.mapView getLayers]add:layer2];
    
    // Set listener to get point click popups
    MyMapEventListener* listener = [[MyMapEventListener alloc] init];
    listener.mapView = self.mapView;
    listener.source = vectorSource;
    
    [self.mapView setMapEventListener:listener];
    
    // Animate map to the marker
    NTMapPos* newYork = [projection fromWgs84:[[NTMapPos alloc] initWithX:-74.0059 y:40.7127]];
    [self.mapView setFocusPos:newYork durationSeconds:1];
    [self.mapView setZoom:15 durationSeconds:0];
}

@end

@implementation CartoDBSQLDataSource

- (NTVectorData *)loadElements:(NTCullState *)cullState
{
    NTVectorElementVector *elements = [[NTVectorElementVector alloc] init];
    
    NTMapEnvelope *envelope = [cullState getProjectionEnvelope: self.getProjection];
    
    NTMapPos* min = [[envelope getBounds] getMin];
    NTMapPos* max = [[envelope getBounds] getMax];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:6];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    NSString* base = @"ST_SetSRID(ST_MakeEnvelope(";
    NSString* values = @"";
    
    // Set up coordinates. This logic may vary depending on your region
    NSString* value = [formatter stringFromNumber:[NSNumber numberWithDouble:[min getX]]];
    value = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
    values = [values stringByAppendingString:value];

    values = [values stringByAppendingString:@","];
    
    value = [formatter stringFromNumber:[NSNumber numberWithDouble:[min getY]]];
    value = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
    values = [values stringByAppendingString:value];
    
    values = [values stringByAppendingString:@","];
    
    value = [formatter stringFromNumber:[NSNumber numberWithDouble:[max getX]]];
    value = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
    values = [values stringByAppendingString:value];
    
    values = [values stringByAppendingString:@","];
    
    value = [formatter stringFromNumber:[NSNumber numberWithDouble:[max getY]]];
    value = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
    values = [values stringByAppendingString:value];
    
    NSString* end = @"),3857) && the_geom_webmercator";
    
    NSString* bbox = [[base stringByAppendingString:values] stringByAppendingString:end];
    
    NSLog(@"BBOX %@", bbox);
    
    NSString* zoom = [formatter stringFromNumber:[NSNumber numberWithFloat:[[cullState getViewState] getZoom]]];
    
    NSString* unencoded = [self.query stringByReplacingOccurrencesOfString:@"!bbox!" withString:bbox];
    unencoded = [unencoded stringByReplacingOccurrencesOfString:@"zoom('!scale_denominator!')" withString:zoom];
    
    NSString* encoded = [unencoded stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    // Additional encoding
    encoded = [encoded stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"(" withString:@"%28"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@")" withString:@"%29"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"," withString:@"%2c"];
    encoded = [encoded stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    
    NSString* fullPath = [[self.baseUrl stringByAppendingString:@"?format=GeoJSON&q="] stringByAppendingString:encoded];
    
    NSLog(@"URL %@", fullPath);

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:fullPath]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];

    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"SUCCESS %@", json);
    
    NTGeoJSONGeometryReader* reader = [[NTGeoJSONGeometryReader alloc]init];
    NTFeatureCollection* collection = [reader readFeatureCollection:json];

    for (int i = 0; i < collection.getFeatureCount; i++)
    {
        NTFeature* feature = [collection getFeature:i];
        
        NTGeometry* geometry = [feature getGeometry];
        NTVariant* props = [feature getProperties];
        
        NTVectorElement* element;
        
        if ([self.style isKindOfClass:[NTPointStyle class]]) {
            element = [[NTPoint alloc]initWithGeometry:geometry style:self.style];
        } else if ([self.style isKindOfClass:[NTMarkerStyle class]]) {
            element = [[NTMarker alloc]initWithGeometry:geometry style:self.style];
        } else if ([self.style isKindOfClass:[NTMarkerStyle class]]) {
            element = [[NTLine alloc]initWithGeometry:geometry style:self.style];
        } else if ([self.style isKindOfClass:[NTLineGeometry class]]) {
            element = [[NTPoint alloc]initWithGeometry:geometry style:self.style];
        } else if ([self.style isKindOfClass:[NTPolygonStyle class]]) {
            element = [[NTPolygon alloc]initWithGeometry:geometry style:self.style];
        } else {
            NSLog(@"ERROR: Incompatible format");
        }
        
        for (int j = 0; j < [[props getObjectKeys] size]; j++) {
            
            NSString* key = [[props getObjectKeys] get:j];
            NTVariant* value = [props getObjectElement:key];
            
            [element setMetaDataElement:key element:value];
        }
        
        [elements add:element];
    }

    NSLog(@"FINISHED| Element count: %u", [elements size]);
    return [[NTVectorData alloc]initWithElements:elements];
}

@end





