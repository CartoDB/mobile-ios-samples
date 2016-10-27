
#import "MapBaseController.h"

@interface ClusteredGeoJsonController : MapBaseController

@end

@interface MyMarkerClusterElementBuilder : NTClusterElementBuilder

@end

@implementation ClusteredGeoJsonController

-(void)viewDidLoad
{
    [super viewDidLoad];

    // Initialize a local vector data source
    NTProjection* projection = [[self.mapView getOptions] getBaseProjection];
    NTLocalVectorDataSource* vectorDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:projection];

    // Create element builder
    MyMarkerClusterElementBuilder* clusterElementBuilder = [[MyMarkerClusterElementBuilder alloc] init];
    
    // Initialize a vector layer with the previous data source
    NTClusteredVectorLayer* vectorLayer = [[NTClusteredVectorLayer alloc] initWithDataSource:vectorDataSource clusterElementBuilder:clusterElementBuilder];
    
    // Add the previous vector layer to the map
    [[self.mapView getLayers] add:vectorLayer];
    
    // Read .geojson
    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"cities15000" ofType:@"geojson"];
    NSString* json = [NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil];
    
    // .geojson parsing
    NTGeoJSONGeometryReader* geoJsonReader = [[NTGeoJSONGeometryReader alloc] init];
    [geoJsonReader setTargetProjection:projection];
    
    NTFeatureCollection* features = [geoJsonReader readFeatureCollection:json];
    
    // Initialize basic style, as it will later be overridden anyway
    NTMarkerStyle *style = [[[NTMarkerStyleBuilder alloc] init] buildStyle];
    
    for (int i = 0; i < [features getFeatureCount]; i++) {
        NTPointGeometry *geometry = [[features getFeature:i] getGeometry];
        
        NTMarker *marker = [[NTMarker alloc] initWithGeometry:geometry style:style];
        [vectorDataSource add:marker];
    }
}

@end

@interface MyMarkerClusterElementBuilder ()

@property NSMutableDictionary* markerStyles;

@end

@implementation MyMarkerClusterElementBuilder

-(NTVectorElement*)buildClusterElement:(NTMapPos *)mapPos elements:(NTVectorElementVector *)elements
{
    if (!self.markerStyles) {
        self.markerStyles = [NSMutableDictionary new];
    }
    
    NSString* styleKey = [NSString stringWithFormat:@"%d",(int)[elements size]];
    
    NTMarkerStyle* markerStyle = [self.markerStyles valueForKey:styleKey];
    
    if ([elements size] == 1) {
        markerStyle = [(NTMarker*)[elements get:0] getStyle];
    }
    
    if (!markerStyle) {
        
        UIImage* image = [UIImage imageNamed:@"marker_black.png"];
        
        UIGraphicsBeginImageContext(image.size);
        [image drawAtPoint:CGPointMake(0, 0)];
        
        CGRect rect = CGRectMake(0, 15, image.size.width, image.size.height);
        [[UIColor blackColor] set];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentCenter];
        
        NSDictionary *attr = [NSDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName];
        [styleKey drawInRect:CGRectIntegral(rect) withAttributes:attr];
        
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NTBitmap* markerBitmap = [NTBitmapUtils createBitmapFromUIImage:newImage];
        NTMarkerStyleBuilder* markerStyleBuilder = [[NTMarkerStyleBuilder alloc] init];
        
        [markerStyleBuilder setBitmap:markerBitmap];
        [markerStyleBuilder setSize:30];
        [markerStyleBuilder setHideIfOverlapped:NO];
        [markerStyleBuilder setPlacementPriority:-(int)[elements size]];
        
        markerStyle = [markerStyleBuilder buildStyle];
        [self.markerStyles setValue:markerStyle forKey:styleKey];
    }
    
    NTMarker* marker = [[NTMarker alloc] initWithPos:mapPos style:markerStyle];
    [marker setMetaDataElement:@"elements" element:[[NTVariant alloc] initWithLongVal:[elements size]]];
    
    return marker;
}

@end







