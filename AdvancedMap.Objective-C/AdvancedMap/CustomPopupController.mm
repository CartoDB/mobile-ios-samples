#import "MapBaseController.h"
#import "MyCustomPopupHandler.h"

/*
 * A sample demonstrating how to create and use custom popups.
 * Note that Carto Mobile SDK has built-in customizable BalloonPopup class that provides
 * uniform functionality and look across different platforms. But In some cases
 * more customization is needed and Popup subclassing can be used in that case.
 */
@interface CustomPopupController : MapBaseController

@end

@implementation CustomPopupController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    [self.contentView addBaseLayer: NT_CARTO_BASEMAP_STYLE_VOYAGER];
    
	// Initialize a local vector data source
	NTProjection* proj = [[self.contentView.mapView getOptions] getBaseProjection];
	NTLocalVectorDataSource* vectorDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
	// Initialize a vector layer with the previous data source
	NTVectorLayer* vectorLayer = [[NTVectorLayer alloc] initWithDataSource:vectorDataSource];
	// Add the previous vector layer to the map
	[[self.contentView.mapView getLayers] add:vectorLayer];
	
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
    [marker setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Marker nr 1"]];
	[vectorDataSource add:marker];
	
	// Add custom popup
    // Create custom style for the popup - use special attachment anchor point a bit right from the center
    NTPopupStyleBuilder* styleBuilder = [[NTPopupStyleBuilder alloc] init];
    [styleBuilder setAttachAnchorPointX:0.5f attachAnchorPointY:0];
    NTPopupStyle* style = [styleBuilder buildStyle];

    // Create custom popup handler that is responsible for drawing and responding to click events
    MyCustomPopupHandler* popupHandler = [[MyCustomPopupHandler alloc] initWithText:@"custom popup\nattached to marker"];
    
    // Create custom popup
    NTCustomPopup* popup = [[NTCustomPopup alloc] initWithBaseBillboard:marker style:style popupHandler:popupHandler];
    [popup setAnchorPointX:-1.0f anchorPointY:0.0f];
	[vectorDataSource add:popup];
}

@end
