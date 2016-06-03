#import "VectorMapSampleBaseController.h"
#import "CustomPopup.h"

/*
 * A sample demonstrating how to create and use custom popups.
 * Note that Carto Mobile SDK has built-in customizable BalloonPopup class that provides
 * uniform functionality and look across different platforms. But In some cases
 * more customization is needed and Popup subclassing can be used in that case.
 */
@interface CustomPopupSampleController : VectorMapSampleBaseController

@end

@implementation CustomPopupSampleController

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
	
	// Create a marker style, set anchor attachment point to the left
	NTMarkerStyleBuilder* markerStyleBuilder = [[NTMarkerStyleBuilder alloc] init];
	[markerStyleBuilder setBitmap:markerBitmap];
	[markerStyleBuilder setSize:30];
	NTMarkerStyle* sharedMarkerStyle = [markerStyleBuilder buildStyle];
	
	// Add marker
	NTMapPos* pos = [proj fromWgs84:[[NTMapPos alloc] initWithX:24.646469 y:59.426939]];
	NTMarker* marker = [[NTMarker alloc] initWithPos:pos style:sharedMarkerStyle];
	[marker setMetaDataElement:@"ClickText" element:@"Marker nr 1"];
	[vectorDataSource add:marker];
	
	// Add custom popup
	CustomPopup* popup = [[CustomPopup alloc] initWithBaseBillboard:marker text:@"custom popup\nattached to marker"];
	[vectorDataSource add:popup];
}

@end
