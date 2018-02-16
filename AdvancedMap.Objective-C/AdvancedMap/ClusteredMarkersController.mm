
#import "MapBaseController.h"

@interface ClusteredMarkersController : MapBaseController

@end

@interface MyMarkerClusterElementBuilder : NTClusterElementBuilder

@end

@implementation ClusteredMarkersController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.contentView addBaseLayer: NT_CARTO_BASEMAP_STYLE_POSITRON];
    
    // Initialize a local vector data source
    NTProjection* projection = [[self.contentView.mapView getOptions] getBaseProjection];
    NTLocalVectorDataSource* vectorDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:projection];

    // Create element builder
    MyMarkerClusterElementBuilder* clusterElementBuilder = [[MyMarkerClusterElementBuilder alloc] init];
    
    // Initialize a vector layer with the previous data source
    NTClusteredVectorLayer* vectorLayer = [[NTClusteredVectorLayer alloc] initWithDataSource:vectorDataSource clusterElementBuilder:clusterElementBuilder];
    
    // Add the previous vector layer to the map
    [[self.contentView.mapView getLayers] add:vectorLayer];
    
    // Read .geojson
    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"cities15000" ofType:@"geojson"];
    NSString* json = [NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil];
    
    // .geojson parsing
    NTGeoJSONGeometryReader* geoJsonReader = [[NTGeoJSONGeometryReader alloc] init];
    [geoJsonReader setTargetProjection:projection];
    
    NTFeatureCollection* features = [geoJsonReader readFeatureCollection:json];

    // Create style for markers
    NTMarkerStyleBuilder* markerStyleBuilder = [[NTMarkerStyleBuilder alloc] init];
    [markerStyleBuilder setSize: 14.0f];
    NTMarkerStyle* style = [markerStyleBuilder buildStyle];

    // Add the loaded feature collection to the data source
    [vectorDataSource addFeatureCollection:features style:style];
}

@end

@interface MyMarkerClusterElementBuilder ()

@property NSMutableDictionary* markerStyles;
@property UIImage* markerImage;

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
        
        if (!self.markerImage) {
            self.markerImage = [UIImage imageNamed:@"marker_black.png"];
        }
        
        UIGraphicsBeginImageContext(self.markerImage.size);
        [self.markerImage drawAtPoint:CGPointMake(0, 0)];
        
        CGRect rect = CGRectMake(0, 15, self.markerImage.size.width, self.markerImage.size.height);
        [[UIColor blackColor] set];
        
        NSMutableParagraphStyle* style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentCenter];
        
        NSDictionary* attr = [NSDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName];
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







