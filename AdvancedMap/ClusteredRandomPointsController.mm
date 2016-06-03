#import "VectorMapSampleBaseController.h"

/*
 * A sample demonstrating how to use marker clustering on the map. This demo creates
 * 1000 randomly positioned markers on the map and uses SDKs built-in clustering layer
 * with custom 'ClusterElementBuilder' implementation that draws the number of cluster elements
 * dynamically on a marker bitmap.
 *
 * The custom cluster element builder also caches created marker styles, to conserve memory
 * usage and to avoid redundant calculations.
 *
 * The sample also uses a custom map listener that expands cluster elements that are clicked on, if
 * the number of elements in the cluster is less than or equal to 5.
 */
@interface ClusteredRandomPointsController : VectorMapSampleBaseController

@end

@interface MyMarkerClusterElementBuilder : NTClusterElementBuilder

@end

@interface ClusteredRandomPointsController ()

@end

@implementation ClusteredRandomPointsController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mapView setZoom:7.5f durationSeconds:0.0f];
    
    // Load bitmaps for custom markers
    UIImage* markerImage = [UIImage imageNamed:@"marker_red.png"];
    NTBitmap* markerBitmap = [NTBitmapUtils createBitmapFromUIImage:markerImage];
    
    // Create a marker style, use it for both markers, because they should look the same
    NTMarkerStyleBuilder* markerStyleBuilder = [[NTMarkerStyleBuilder alloc] init];
    [markerStyleBuilder setBitmap:markerBitmap];
    [markerStyleBuilder setSize:30];
    NTMarkerStyle* sharedMarkerStyle = [markerStyleBuilder buildStyle];
    
    // Initialize a local vector data source
    NTProjection* proj = [[self.mapView getOptions] getBaseProjection];
    NTLocalVectorDataSource* vectorDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
    
    // Create marker, add it to the data source
    for (int i = 0; i < 1000; i++) {
        double x = rand() / (double) RAND_MAX;
        double y = rand() / (double) RAND_MAX;
        NTMapPos* pos = [proj fromWgs84:[[NTMapPos alloc] initWithX:24.646469 + x y:59.426939 + y]]; // Tallinn
        NTMarker* marker = [[NTMarker alloc] initWithPos:pos style:sharedMarkerStyle];
        [vectorDataSource add:marker];
    }
    
    // Create element builder
    MyMarkerClusterElementBuilder* clusterElementBuilder = [[MyMarkerClusterElementBuilder alloc] init];
    
    // Initialize a vector layer with the previous data source
    NTClusteredVectorLayer* vectorLayer = [[NTClusteredVectorLayer alloc] initWithDataSource:vectorDataSource clusterElementBuilder:clusterElementBuilder];
    
    // Add the previous vector layer to the map
    [[self.mapView getLayers] add:vectorLayer];
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
    if ([elements size] > 1000) {
        styleKey = @">1K";
    }
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
    [marker setMetaDataElement:@"elements" element:[@([elements size]) stringValue]];
    return marker;
}

@end
