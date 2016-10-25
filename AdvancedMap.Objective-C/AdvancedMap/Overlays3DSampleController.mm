#import "VectorMapSampleBaseController.h"
#import "MyMapEventListener.h"
#import "MyVectorElementEventListener.h"
/**
 * A sample demonstrating how to use 3D vector elements:
 * 3D polygon, 3D model (NML) and 3D city (NMLDB)
 */
@interface Overlays3DSampleController : VectorMapSampleBaseController

@end

@implementation Overlays3DSampleController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Get the base projection set in the base class
	NTProjection* proj = [[self.mapView getOptions] getBaseProjection];
	
	// Initialize a local vector data source
	NTLocalVectorDataSource* vectorDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
	
    // Initialize a vector layer with the previous data source
	NTVectorLayer* vectorLayer = [[NTVectorLayer alloc] initWithDataSource:vectorDataSource];
	
    // Add the previous vector layer to the map
	[[self.mapView getLayers] add:vectorLayer];
	
    // Set visible zoom range for the vector layer
	[vectorLayer setVisibleZoomRange:[[NTMapRange alloc] initWithMin:10 max:24]];
	
	// Create 3D polygon style and poses
	NTPolygon3DStyleBuilder* polygon3DStyleBuilder = [[NTPolygon3DStyleBuilder alloc] init];
	[polygon3DStyleBuilder setColor:[[NTColor alloc] initWithColor:0x803333FF]];
    [polygon3DStyleBuilder setSideColor:[[NTColor alloc] initWithColor:0xFFFFFFFF]];
	
	NTMapPosVector* polygon3DPoses = [[NTMapPosVector alloc] init];
	[polygon3DPoses add:[proj fromWgs84:[[NTMapPos alloc] initWithX:24.635930 y:59.416659]]];
	[polygon3DPoses add:[proj fromWgs84:[[NTMapPos alloc] initWithX:24.642453 y:59.411354]]];
	[polygon3DPoses add:[proj fromWgs84:[[NTMapPos alloc] initWithX:24.646187 y:59.409607]]];
	[polygon3DPoses add:[proj fromWgs84:[[NTMapPos alloc] initWithX:24.652667 y:59.413123]]];
	[polygon3DPoses add:[proj fromWgs84:[[NTMapPos alloc] initWithX:24.650736 y:59.416703]]];
	[polygon3DPoses add:[proj fromWgs84:[[NTMapPos alloc] initWithX:24.646444 y:59.416245]]];
	
	// Create 3D polygon holes poses
    NTMapPosVector* polygon3DHolePoses = [[NTMapPosVector alloc] init];
	[polygon3DHolePoses add:[proj fromWgs84:[[NTMapPos alloc] initWithX:24.643409 y:59.411922]]];
	[polygon3DHolePoses add:[proj fromWgs84:[[NTMapPos alloc] initWithX:24.651207 y:59.412896]]];
	[polygon3DHolePoses add:[proj fromWgs84:[[NTMapPos alloc] initWithX:24.643207 y:59.414411]]];
    NTMapPosVectorVector* polygon3DHoles = [[NTMapPosVectorVector alloc] init];
    [polygon3DHoles add:polygon3DHolePoses];
	
	// Add to datasource
	NTPolygon3D* polygon3D = [[NTPolygon3D alloc] initWithGeometry:[[NTPolygonGeometry alloc] initWithPoses:polygon3DPoses holes:polygon3DHoles] style:[polygon3DStyleBuilder buildStyle] height: 150];
	[polygon3D setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Polygon3D"]];
	[vectorDataSource add:polygon3D];

	// Add a single 3D model to map
    NSArray* assets = @[@"fcd_auto.nml"];
    int counter = 0;
    for (NSString* asset in assets) {
        NTBinaryData* modelData = [NTAssetUtils loadAsset:asset];
        float dx = (counter++) * 0.001f;
        NTMapPos* pos = [proj fromWgs84:[[NTMapPos alloc] initWithX:24.646469+dx y:59.424939]];
        NTNMLModel* model = [[NTNMLModel alloc] initWithPos:pos sourceModelData:modelData];
        [model setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"NMLModel"]];
        // oversize it 10*, just to make it more visible
        [model setScale:10];
        [vectorDataSource add:model];
    }

    // Create a map event listener
    MyMapEventListener* mapListener = [[MyMapEventListener alloc] init];
    [mapListener setMapView:self.mapView vectorDataSource:vectorDataSource];
    [self.mapView setMapEventListener:mapListener];
    
    // Create vector element event listener
    MyVectorElementEventListener* vectorElementListener = [[MyVectorElementEventListener alloc] init];
    
    [vectorElementListener setMapView:self.mapView vectorDataSource:vectorDataSource];
    
    for (int i = 0; i < [[self.mapView getLayers] count]; i++) {
        NTLayer* layer = [[self.mapView getLayers] get:i];
        if ([layer isKindOfClass:[NTVectorLayer class]]) {
            NTVectorLayer* vectorLayer = (NTVectorLayer*) layer;
            [vectorLayer setVectorElementEventListener:vectorElementListener];
        }
    }
}

@end
