#import "VectorMapSampleBaseController.h"

/*
 * A sample demonstrating how to use markers on the map. This involves creating
 * a data source for the markers, creating a layer using the data source, loading
 * marker bitmaps, creating style for the marker and finally adding the marker to the data source.
 * For multiple markers, the same data source, layer and style should be reused if possible.
 */
@interface PinSampleController : VectorMapSampleBaseController

@end

@implementation PinSampleController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Initialize a local vector data source
	NTProjection* proj = [[self.mapView getOptions] getBaseProjection];
	NTLocalVectorDataSource* vectorDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
	// Initialize a vector layer with the previous data source
	NTVectorLayer* vectorLayer = [[NTVectorLayer alloc] initWithDataSource:vectorDataSource];
	// Add the previous vector layer to the map
	[[self.mapView getLayers] add:vectorLayer];
		
	// Load bitmaps for custom markers
	UIImage* markerImage = [UIImage imageNamed:@"marker.png"];
	NTBitmap* markerBitmap = [NTBitmapUtils createBitmapFromUIImage:markerImage];
	
	// Create a marker style
	NTMarkerStyleBuilder* markerStyleBuilder = [[NTMarkerStyleBuilder alloc] init];
	[markerStyleBuilder setBitmap:markerBitmap];
	[markerStyleBuilder setSize:30];
	NTMarkerStyle* sharedMarkerStyle = [markerStyleBuilder buildStyle];

	// First marker
	NTMapPos* pos = [proj fromWgs84:[[NTMapPos alloc] initWithX:24.646469 y:59.426939]];
	NTMarker* marker = [[NTMarker alloc] initWithPos:pos style:sharedMarkerStyle];
	[marker setMetaDataElement:@"ClickText" element:@"Marker nr 1"];
	[vectorDataSource add:marker];
}

@end
