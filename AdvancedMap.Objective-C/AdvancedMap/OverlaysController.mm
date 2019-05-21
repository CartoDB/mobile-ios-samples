
#import "MapBaseController.h"
#import "MyVectorElementEventListener.h"

/*
 * A sample demonstrating how to add 2D & 3d objects to the map
 */
@interface OverlaysController : MapBaseController

@property NTVectorLayer *layer;
@property NTLocalVectorDataSource *source;
@property NTProjection *projection;

@end

@implementation OverlaysController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    [self.contentView addBaseLayer: NT_CARTO_BASEMAP_STYLE_POSITRON];
    
	// Get the base projection set in the base class
	self.projection = [[self.contentView.mapView getOptions] getBaseProjection];
	
	// Initialize a local vector data source
	self.source = [[NTLocalVectorDataSource alloc] initWithProjection:self.projection];
	
    // Initialize a vector layer with the previous data source
	self.layer = [[NTVectorLayer alloc] initWithDataSource:self.source];
	
    // Add the previous vector layer to the map
	[[self.contentView.mapView getLayers] add:self.layer];
	
    // Set visible zoom range for the vector layer
	[self.layer setVisibleZoomRange:[[NTMapRange alloc] initWithMin:10 max:24]];
	
    [self addPoint1];
    [self addPoint2];
    
    [self addPolygon];
    
    [self addOverlyingLines];
    
    // Load bitmaps for custom markers
	UIImage* markerImage = [UIImage imageNamed:@"marker.png"];
	NTBitmap* markerBitmap = [NTBitmapUtils createBitmapFromUIImage:markerImage];
	
	// Create text style
	NTTextStyleBuilder* textStyleBuilder = [[NTTextStyleBuilder alloc] init];
	[textStyleBuilder setColor:[[NTColor alloc] initWithColor:0xFFFF0000]];
	[textStyleBuilder setOrientationMode:NT_BILLBOARD_ORIENTATION_FACE_CAMERA];
	// This enables higher resolution texts for retina devices  but consumes more memory and is slower
	[textStyleBuilder setScaleWithDPI:NO];
	// Add text
	NTMapPos *pos = [self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.653302 y:59.422269]];
	NTText* text1 = [[NTText alloc] initWithPos:pos style:[textStyleBuilder buildStyle] text:@"Face camera"];
	
    [text1 setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Text nr 1"]];
	[self.source add:text1];
	
    // Add text
	textStyleBuilder = [[NTTextStyleBuilder alloc] init];
	[textStyleBuilder setOrientationMode:NT_BILLBOARD_ORIENTATION_FACE_CAMERA_GROUND];
	pos = [self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.633216 y:59.426869]];
	NTText* text2 = [[NTText alloc] initWithPos:pos style:[textStyleBuilder buildStyle] text:@"Face camera ground"];
	[text2 setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Text nr 2"]];
	[self.source add:text2];
	
    // Add text
	textStyleBuilder = [[NTTextStyleBuilder alloc] init];
	[textStyleBuilder setFontSize:22];
	[textStyleBuilder setOrientationMode:NT_BILLBOARD_ORIENTATION_GROUND];
	pos = [self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.646457 y:59.420839]];
	NTText* text3 = [[NTText alloc] initWithPos:pos style:[textStyleBuilder buildStyle] text:@"Ground"];
	[text3 setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Text nr 3"]];
	[self.source add:text3];
	
	// Create a marker style, use it for both markers, because they should look the same
	NTMarkerStyleBuilder* markerStyleBuilder = [[NTMarkerStyleBuilder alloc] init];
	[markerStyleBuilder setBitmap:markerBitmap];
	[markerStyleBuilder setSize:30];
	NTMarkerStyle* sharedMarkerStyle = [markerStyleBuilder buildStyle];
	// First marker
	pos = [self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.646469 y:59.426939]];
	NTMarker* marker1 = [[NTMarker alloc] initWithPos:pos style:sharedMarkerStyle];
	[marker1 setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Marker nr 1"]];
	[self.source add:marker1];
	
    // Second marker
	pos = [self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.666469 y:59.422939]];
	NTMarker* marker2 = [[NTMarker alloc] initWithPos:pos style:sharedMarkerStyle];
	[marker2 setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Marker nr 2"]];
	[self.source add:marker2];
	
	// Load bitmaps to show on the popups
	UIImage* infoImage = [UIImage imageNamed:@"info.png"];
	UIImage* arrowImage = [UIImage imageNamed:@"arrow.png"];
	
	// First popup, create style and position
	NTBalloonPopupStyleBuilder* balloonPopupStyleBuilder = [[NTBalloonPopupStyleBuilder alloc] init];
	[balloonPopupStyleBuilder setCornerRadius:20];
	[balloonPopupStyleBuilder setLeftMargins:[[NTBalloonPopupMargins alloc] initWithLeft:6 top:6 right:6 bottom:6]];
	[balloonPopupStyleBuilder setLeftImage:[NTBitmapUtils createBitmapFromUIImage:infoImage]];
	[balloonPopupStyleBuilder setRightImage:[NTBitmapUtils createBitmapFromUIImage:arrowImage]];
	[balloonPopupStyleBuilder setRightMargins:[[NTBalloonPopupMargins alloc] initWithLeft:2 top:6 right:12 bottom:6]];
	[balloonPopupStyleBuilder setPlacementPriority:1];
    pos = [self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.655662 y:59.425521]];
	// Add to datasource
	NTBalloonPopup* popup1 = [[NTBalloonPopup alloc] initWithPos:pos style:[balloonPopupStyleBuilder buildStyle] title:@"Popup with pos" desc:@"Images, round"];
	[popup1 setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Popup nr 1"]];
	[self.source add:popup1];
    // Add button to the popup
    NTBalloonPopupButtonStyleBuilder* balloonPopupButtonStyleBuilder = [[NTBalloonPopupButtonStyleBuilder alloc] init];
    [balloonPopupButtonStyleBuilder setColor:[[NTColor alloc] initWithColor:0xff000000]];
    [balloonPopupButtonStyleBuilder setTextColor:[[NTColor alloc] initWithColor:0xffffffff]];
    NTBalloonPopupButton* balloonPopupButton1 = [[NTBalloonPopupButton alloc] initWithStyle:[balloonPopupButtonStyleBuilder buildStyle] text:@"Button1"];
    [popup1 addButton: balloonPopupButton1];

	// Second popup, but instead of giving it a position attach it to a marker
	balloonPopupStyleBuilder = [[NTBalloonPopupStyleBuilder alloc] init];
	[balloonPopupStyleBuilder setColor:[[NTColor alloc] initWithColor:0xFF000000]];
	[balloonPopupStyleBuilder setCornerRadius:0];
	[balloonPopupStyleBuilder setTitleColor:[[NTColor alloc] initWithColor:0xFFFFFFFF]];
	[balloonPopupStyleBuilder setTitleFontName:@"HelveticaNeue-Medium"];
	[balloonPopupStyleBuilder setDescriptionColor:[[NTColor alloc] initWithColor:0xFFFFFFFF]];
	[balloonPopupStyleBuilder setDescriptionFontName:@"HelveticaNeue-Medium"];
	[balloonPopupStyleBuilder setStrokeColor:[[NTColor alloc] initWithColor:0xFF00B483]];
	[balloonPopupStyleBuilder setStrokeWidth:0];
	[balloonPopupStyleBuilder setPlacementPriority:1];
	// Add to datasource
	NTBalloonPopup* popup2 = [[NTBalloonPopup alloc] initWithBaseBillboard:marker1 style:[balloonPopupStyleBuilder buildStyle] title:@"Popup attached to marker" desc:@"ru: тест"];
	[popup2 setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Popup nr 2"]];
	[self.source add:popup2];
	
	// Third popup, create a style and position
	balloonPopupStyleBuilder = [[NTBalloonPopupStyleBuilder alloc] init];
	[balloonPopupStyleBuilder setDescriptionWrap:NO];
	[balloonPopupStyleBuilder setPlacementPriority:1];
	pos = [self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.658662 y:59.432521]];
	// Add to datasource
	NTBalloonPopup* popup3 = [[NTBalloonPopup alloc] initWithPos:pos style:[balloonPopupStyleBuilder buildStyle] title:@"This title will be wrapped if there's not enough space on the screen." desc:@"Description is set to be truncated with three dots, unless the screen is really really big."];
	
    [popup3 setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Popup nr 3"]];
	
    [self.source add:popup3 ];
    
    [self add3DPolygon];
    
    [self add3DCar];

    // Set initial location and other parameters, don't animate
    [self.contentView.mapView setFocusPos:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.650415 y:59.428773]]  durationSeconds:0];
    [self.contentView.mapView setZoom:13 durationSeconds:0];
    
    // Create vector element event listener
    MyVectorElementEventListener* vectorElementListener = [[MyVectorElementEventListener alloc] init];
    [vectorElementListener setMapView:self.contentView.mapView vectorDataSource:self.source];
    
    for (int i = 0; i < [[self.contentView.mapView getLayers] count]; i++) {
        
        NTLayer* layer = [[self.contentView.mapView getLayers] get:i];
        
        if ([layer isKindOfClass:[NTVectorLayer class]]) {
            NTVectorLayer* vectorLayer = (NTVectorLayer*) layer;
            [vectorLayer setVectorElementEventListener:vectorElementListener];
        }
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    
    // Reset all listeners. Without this the sample would leak due to cyclical references between MapView and listeners
    for (int i = 0; i < [[self.contentView.mapView getLayers] count]; i++) {
        
        NTLayer* layer = [[self.contentView.mapView getLayers] get:i];
        
        if ([layer isKindOfClass:[NTVectorLayer class]]) {
            NTVectorLayer* vectorLayer = (NTVectorLayer*) layer;
            [vectorLayer setVectorElementEventListener:nil];
        }
    }
}

-(void) addPoint1
{
    NTPointStyleBuilder* builder = [[NTPointStyleBuilder alloc] init];
    [builder setColor:[[NTColor alloc] initWithColor:0xFF00FF00]];
    [builder setSize:16];gs84:
    NTMapPos* pos = [self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.651488 y:59.423581]];
    
    NTPoint* point = [[NTPoint alloc] initWithPos:pos style:[builder buildStyle]];
    
    [point setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Point nr 1"]];
    
    [self.source add:point];
}

-(void) addPoint2
{
    NTPointStyleBuilder *builder = [[NTPointStyleBuilder alloc] init];
    [builder setColor:[[NTColor alloc] initWithColor:0xFF0000FF]];
   
    NTMapPos *pos = [self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.655994 y:59.422716]];
    NTPoint* point = [[NTPoint alloc] initWithPos:pos style:[builder buildStyle]];
    
    [point setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Point nr 2"]];
    
    [self.source add:point];
}

-(void) addPolygon
{
    NTPolygonStyleBuilder* polygonBuilder = [[NTPolygonStyleBuilder alloc] init];
    [polygonBuilder setColor:[[NTColor alloc] initWithColor:0xFFFF0000]];
    
    NTLineStyleBuilder *lineBuilder = [[NTLineStyleBuilder alloc] init];
    [lineBuilder setColor:[[NTColor alloc] initWithColor:0xFF000000]];
    [lineBuilder setWidth:1.0f];
    
    [polygonBuilder setLineStyle:[lineBuilder buildStyle]];
    
    NTMapPosVector* polygonPoses = [[NTMapPosVector alloc] init];
    [polygonPoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.650930 y:59.421659]]];
    [polygonPoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.657453 y:59.416354]]];
    [polygonPoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.661187 y:59.414607]]];
    [polygonPoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.667667 y:59.418123]]];
    [polygonPoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.665736 y:59.421703]]];
    [polygonPoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.661444 y:59.421245]]];
    [polygonPoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.660199 y:59.420677]]];
    [polygonPoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.656552 y:59.420175]]];
    [polygonPoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.654010 y:59.421472]]];
    
    // Create polygon holes poses
    NTMapPosVector* holePoses1 = [[NTMapPosVector alloc] init];
    [holePoses1 add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.658409 y:59.420522]]];
    [holePoses1 add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.662207 y:59.418896]]];
    [holePoses1 add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.662207 y:59.417411]]];
    [holePoses1 add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.659524 y:59.417171]]];
    [holePoses1 add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.657615 y:59.419834]]];
    
    NTMapPosVector* holePoses2 = [[NTMapPosVector alloc] init];
    [holePoses2 add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.665640 y:59.421243]]];
    [holePoses2 add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.668923 y:59.419463]]];
    [holePoses2 add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.662893 y:59.419365]]];
    
    NTMapPosVectorVector* holes = [[NTMapPosVectorVector alloc] init];
    [holes add:holePoses1];
    [holes add:holePoses2];
    
    NTPolygon* polygon = [[NTPolygon alloc] initWithGeometry:[[NTPolygonGeometry alloc] initWithPoses:polygonPoses holes:holes] style:[polygonBuilder buildStyle]];
    
    [polygon setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Polygon"]];
    
    [self.source add:polygon];
}

-(void) addOverlyingLines
{
    // Initialize a second vector data source and vector layer.
    // This secondary vector layer will be used for drawing borders for
    // line elements (by drawing the same line twice, with different widths).
    // Drawing order withing a layer is currently undefined.
    // Using multiple layers is the only way to guarantee
    // that point, line and polygon elements are drawn in a specific order.
    NTLocalVectorDataSource* vectorDataSource2 = [[NTLocalVectorDataSource alloc] initWithProjection:self.projection];
    NTVectorLayer* vectorLayer2 = [[NTVectorLayer alloc] initWithDataSource:vectorDataSource2];
    
    [[self.contentView.mapView getLayers] add:vectorLayer2];
    [vectorLayer2 setVisibleZoomRange:[[NTMapRange alloc] initWithMin:10 max:24]];
    
    // Add vector elements. All vector elements need a position, which defines the location
    // and a style, which defines how they look. Styles can be created using StyleBuilders.
    
    // First line, create style and positions
    NTLineStyleBuilder* lineStyleBuilder = [[NTLineStyleBuilder alloc] init];
    [lineStyleBuilder setColor:[[NTColor alloc] initWithColor:0xFFFFFFFF]];
    [lineStyleBuilder setLineJoinType:NT_LINE_JOIN_TYPE_ROUND];
    [lineStyleBuilder setLineEndType:NT_LINE_END_TYPE_SQUARE];
    [lineStyleBuilder setWidth:8];
    
    NTMapPosVector* linePoses = [[NTMapPosVector alloc] init];
    [linePoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.645565 y:59.422074]]];
    [linePoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.643076 y:59.420502]]];
    [linePoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.645351 y:59.419149]]];
    [linePoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.648956 y:59.420393]]];
    [linePoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.650887 y:59.422707]]];

    NTLine* line1 = [[NTLine alloc] initWithGeometry:[[NTLineGeometry alloc] initWithPoses:linePoses] style:[lineStyleBuilder buildStyle]];
    [line1 setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Line nr 1"]];
    [vectorDataSource2 add:line1];
    
    // Second line, create style, reuse the same line position
    lineStyleBuilder = [[NTLineStyleBuilder alloc] init];
    [lineStyleBuilder setColor:[[NTColor alloc] initWithColor:0xFFCC0F00]];
    [lineStyleBuilder setLineJoinType:NT_LINE_JOIN_TYPE_ROUND];
    [lineStyleBuilder setLineEndType:NT_LINE_END_TYPE_SQUARE];
    [lineStyleBuilder setWidth:12];
    
    NTLine* line2 = [[NTLine alloc] initWithGeometry:[[NTLineGeometry alloc] initWithPoses:linePoses] style:[lineStyleBuilder buildStyle]];
    [line2 setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Line nr 2"]];
    
    [self.source add:line2];
}


-(void) add3DCar
{
    // Add a single 3D model to map
    NSString* asset = [@[@"fcd_auto.nml"] objectAtIndex:0];
    int counter = 0;
    
    NTBinaryData* modelData = [NTAssetUtils loadAsset:asset];
    float dx = (counter++) * 0.001f;
    NTMapPos* pos = [self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.646469+dx y:59.424939]];
    NTNMLModel* model = [[NTNMLModel alloc] initWithPos:pos sourceModelData:modelData];
    [model setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"NMLModel"]];
    
    // oversize it 100x, just to make it more visible
    [model setScale:100];
    [self.source add:model];
}

-(void) add3DPolygon
{
    // Create 3D polygon style and poses
    NTPolygon3DStyleBuilder* polygon3DStyleBuilder = [[NTPolygon3DStyleBuilder alloc] init];
    [polygon3DStyleBuilder setColor:[[NTColor alloc] initWithColor:0x803333FF]];
    [polygon3DStyleBuilder setSideColor:[[NTColor alloc] initWithColor:0xFFFFFFFF]];
    
    NTMapPosVector* polygon3DPoses = [[NTMapPosVector alloc] init];
    [polygon3DPoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.635930 y:59.416659]]];
    [polygon3DPoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.642453 y:59.411354]]];
    [polygon3DPoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.646187 y:59.409607]]];
    [polygon3DPoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.652667 y:59.413123]]];
    [polygon3DPoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.650736 y:59.416703]]];
    [polygon3DPoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.646444 y:59.416245]]];
    
    // Create 3D polygon holes poses
    NTMapPosVector* polygon3DHolePoses = [[NTMapPosVector alloc] init];
    [polygon3DHolePoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.643409 y:59.411922]]];
    [polygon3DHolePoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.651207 y:59.412896]]];
    [polygon3DHolePoses add:[self.projection fromWgs84:[[NTMapPos alloc] initWithX:24.643207 y:59.414411]]];
    NTMapPosVectorVector* polygon3DHoles = [[NTMapPosVectorVector alloc] init];
    [polygon3DHoles add:polygon3DHolePoses];
    
    // Add to datasource
    NTPolygon3D* polygon3D = [[NTPolygon3D alloc] initWithGeometry:[[NTPolygonGeometry alloc] initWithPoses:polygon3DPoses holes:polygon3DHoles] style:[polygon3DStyleBuilder buildStyle] height: 150];
    [polygon3D setMetaDataElement:@"ClickText" element:[[NTVariant alloc] initWithString:@"Polygon3D"]];
    [self.source add:polygon3D];
}

@end












