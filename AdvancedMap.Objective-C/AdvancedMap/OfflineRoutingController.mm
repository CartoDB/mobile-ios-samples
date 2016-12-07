#import "MapBaseController.h"
/*
 * Package manager listener. Listener is notified about asynchronous events
 * about packages.
 */
@interface RoutePackageManagerListener : NTPackageManagerListener

- (void)onPackageListUpdated;
- (void)onPackageListFailed;
- (void)onPackageUpdated:(NSString*)packageId version:(int)version;
- (void)onPackageCancelled:(NSString*)packageId version:(int)version;
- (void)onPackageFailed:(NSString*)packageId version:(int)version errorType:(enum NTPackageErrorType)errorType;
- (void)onPackageStatusChanged:(NSString*)packageId version:(int)version status:(NTPackageStatus*)status;

@property UIViewController* routingController;
@property NTPackageManager* packageManager;

@end

@interface  RouteClickListener : NTMapEventListener

@property (strong, nonatomic) NTMapView* mapView;
@property (strong, nonatomic) UIViewController* routingController;

@property (strong, nonatomic) NTMapPos* startPos;
@property (strong, nonatomic) NTMapPos* stopPos;
@property (strong, nonatomic) NTLocalVectorDataSource* routeDataSource;
@property (strong, nonatomic) NTBalloonPopup* oldClickLabel;

@end;

@interface OfflineRoutingController : MapBaseController

 - (void)setStart:(NTMapPos*)mapPos;
 - (void)setStop:(NTMapPos*)mapPos;

@property NTCartoPackageManager* packageManager;
@property RoutePackageManagerListener* _packageManagerListener;

@property RouteClickListener* mapListener;

@property NTLocalVectorDataSource* routeDataSource;
@property NTLocalVectorDataSource* routeStartStopDataSource;

@property NTMarker* startMarker;
@property NTMarker* stopMarker;
@property NTMarkerStyle* instructionUp;
@property NTMarkerStyle* instructionLeft;
@property NTMarkerStyle* instructionRight;
@property NTRoutingService* offlineRoutingService;
@property NTRoutingService* onlineRoutingService;

@property (nonatomic, assign) bool offlinePackageReady;

@end;



@implementation OfflineRoutingController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Get the base projection set in the base class
	NTProjection* proj = [[self.mapView getOptions] getBaseProjection];
	
	// Initialize an online vector data source for base map
	_routeDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
    _routeStartStopDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];

	// Initialize a vector layer with the previous data source
	NTVectorLayer* vectorLayer = [[NTVectorLayer alloc] initWithDataSource:_routeDataSource];
    NTVectorLayer* vectorLayerStartStop = [[NTVectorLayer alloc] initWithDataSource:_routeStartStopDataSource];
    
	// Add the previous vector layer to the map
	[[self.mapView getLayers] add:vectorLayer];
    [[self.mapView getLayers] add:vectorLayerStartStop];

    // Create markers for start and end
    NTMarkerStyleBuilder* markerStyleBuilder = [[NTMarkerStyleBuilder alloc] init];
    [markerStyleBuilder setSize:30];
    [markerStyleBuilder setHideIfOverlapped:NO];
    [markerStyleBuilder setColor:[[NTColor alloc] initWithColor:0xFF00FF00]]; // Green
    
    // Initial empty markers
    _startMarker = [[NTMarker alloc] initWithPos:[[NTMapPos alloc] initWithX:0 y:0] style:[markerStyleBuilder buildStyle]];
    [_startMarker setVisible:NO];
    [_routeStartStopDataSource add: _startMarker];

    // Change color to Red
    [markerStyleBuilder setColor:[[NTColor alloc] initWithColor:0xFFFF0000]];

    _stopMarker = [[NTMarker alloc] initWithPos:[[NTMapPos alloc] initWithX:0 y:0] style:[markerStyleBuilder buildStyle]];
    [_stopMarker setVisible:NO];
    [_routeStartStopDataSource add: _stopMarker];
	

    // Create styles for instruction markers
    [markerStyleBuilder setColor: [[NTColor alloc] initWithColor:0xFFFFFFFF]]; // white
    [markerStyleBuilder setBitmap:[NTBitmapUtils createBitmapFromUIImage:[UIImage imageNamed:@"direction_up.png"]]];
    _instructionUp = [markerStyleBuilder buildStyle];

    [markerStyleBuilder setBitmap:[NTBitmapUtils createBitmapFromUIImage:[UIImage imageNamed:@"direction_upthenleft.png"]]];
    _instructionLeft = [markerStyleBuilder buildStyle];
    
    [markerStyleBuilder setBitmap:[NTBitmapUtils createBitmapFromUIImage:[UIImage imageNamed:@"direction_upthenright.png"]]];
    _instructionRight = [markerStyleBuilder buildStyle];
    
    
	// Create a map event listener
	self.mapListener = [[RouteClickListener alloc] init];
	
    // MapEventListener needs the data source and the layer to display balloons over the clicked vector elements
    [self.mapListener setRoutingController: self];
    [self.mapListener setRouteDataSource:_routeDataSource];

    [self.mapView setFocusPos:[proj fromWgs84:[[NTMapPos alloc] initWithX:25.662893 y:58.919365]]  durationSeconds:0];
    [self.mapView setZoom:7 durationSeconds:0];
    
    // Create folder for package manager. Package manager needs persistent writable folder.
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask,YES);
    NSString* appSupportDir = [paths objectAtIndex: 0];
    NSString* packagesDir = [appSupportDir stringByAppendingString:@"/packages"];
    NSError *error;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:packagesDir withIntermediateDirectories:YES attributes:nil error:&error];
    
    self.packageManager = [[NTCartoPackageManager alloc] initWithSource:@"routing:nutiteq.osm.car" dataFolder:packagesDir];
    
    self._packageManagerListener = [[RoutePackageManagerListener alloc] init];
    
    // Register this controller with listener to receive notifications about events
    [self._packageManagerListener setRoutingController:self];
    [self._packageManagerListener setPackageManager:self.packageManager];

    // Create offline routing service connected to package manager
    _offlineRoutingService = [[NTPackageManagerRoutingService alloc] initWithPackageManager:self.packageManager];
    
    // Create also online routing service if no offline package is yet downloaded
    _onlineRoutingService = [[NTCartoOnlineRoutingService alloc] initWithSource:@"nutiteq.osm.car"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mapView setMapEventListener:self.mapListener];
    
    // Attach package manager listener
    [self.packageManager setPackageManagerListener:self._packageManagerListener];
    
    [self.packageManager start];
    [self.packageManager startPackageListDownload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.mapView setMapEventListener:nil];
    
    [self.packageManager setPackageManagerListener:nil];
    [self.packageManager stop:true];
}

-(void)setStart:(NTMapPos *)mapPos
{
    [_routeDataSource clear];
    [_stopMarker setVisible:NO];
    [_startMarker setPos:mapPos];
    [_startMarker setVisible:YES];
    
}

-(void)setStop:(NTMapPos *)mapPos
{
    [_stopMarker setPos:mapPos];
    [_stopMarker setVisible:YES];
    [self showRoute: [[_startMarker getGeometry] getCenterPos] stopPos: [[_stopMarker getGeometry] getCenterPos]];
}

// Calculate route, show on map
-(void)showRoute: (NTMapPos *)startPos stopPos:(NTMapPos *)stopPos
{
     NTMapPosVector* poses = [[NTMapPosVector alloc] init];
     [poses add:startPos];
     [poses add:stopPos];
    

    NTRoutingRequest* request = [[NTRoutingRequest alloc] initWithProjection:[[self.mapView getOptions] getBaseProjection] points:poses];
    
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    // Calculation should be in background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NTRoutingResult* route;
        
        @try {
            if (_offlinePackageReady) {
                [self alert:@"Using offline routing"];
                route = [_offlineRoutingService calculateRoute:request];
            } else {
                [self alert:@"Using online routing"];
                route = [_onlineRoutingService calculateRoute:request];
            }
        }
        @catch (NSException* ex) {
            [self alert:[NSString stringWithFormat:@"routing failed: %@", [ex reason]]];
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSTimeInterval duration = [NSDate timeIntervalSinceReferenceDate] - start;
            
            if (route == nil) {
                [self alert:@"route error"];
                return;
            }
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            
            NSString* routeDesc = [NSString stringWithFormat:@"Route: %0.3f km, travel %@. Calculation took %0.3f s", [route getTotalDistance]/1000.0, [dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:[route getTotalTime]]], duration];
            
            [self alert:[NSString stringWithFormat:@"%@",routeDesc]];
            
            // Show line
            NTLine* routeLine = [self calculateRouteLine: route];
            
            [routeLine setMetaDataElement:@"desc" element:[[NTVariant alloc] initWithString:routeDesc]];
            
            [_routeDataSource add: routeLine];
            
            // Show instructions as popups
            for(int i=0;i<[[route getInstructions] size];i++) {
                
                NTRoutingInstruction *instruction =[[route getInstructions] get:i];
                NTMarker* popup = [self createRoutePoint: instruction point: [[route getPoints] get:[instruction getPointIndex]]];
                
                if( popup != nil) {
                    [_routeDataSource add:popup];
                }
            }
        });
    });
}

-(NTMarker*) createRoutePoint: (NTRoutingInstruction*) instruction point:(NTMapPos*) pos
{
    NTMarkerStyle* style = _instructionUp;
    NSString* str = @"";
    
    switch ([instruction getAction]) {
        case NT_ROUTING_ACTION_HEAD_ON:
            str = @"head on";
            break;
        case NT_ROUTING_ACTION_FINISH:
            str = @"finish";
            break;
        case NT_ROUTING_ACTION_TURN_LEFT:
            style = _instructionLeft;
            str = @"turn left";
            break;
        case NT_ROUTING_ACTION_TURN_RIGHT:
            style = _instructionRight;
            str = @"turn right";
            break;
        case NT_ROUTING_ACTION_UTURN:
            str = @"u turn";
            break;
        case NT_ROUTING_ACTION_NO_TURN:
        case NT_ROUTING_ACTION_GO_STRAIGHT:
            str = @"continue";
            break;
        case NT_ROUTING_ACTION_REACH_VIA_LOCATION:
            str = @"stopover";
            break;
        case NT_ROUTING_ACTION_ENTER_AGAINST_ALLOWED_DIRECTION:
            str = @"enter against allowed direction";
            break;
        case NT_ROUTING_ACTION_LEAVE_AGAINST_ALLOWED_DIRECTION:
            break;
        case NT_ROUTING_ACTION_ENTER_ROUNDABOUT:
            str = @"enter roundabout";
            break;
        case NT_ROUTING_ACTION_STAY_ON_ROUNDABOUT:
            str = @"stay on roundabout";
            break;
        case NT_ROUTING_ACTION_LEAVE_ROUNDABOUT:
            str = @"leave roundabout";
            break;
        case NT_ROUTING_ACTION_START_AT_END_OF_STREET:
            str = @"start at end of street";
            break;
    }
    
    NSString* desc =[NSString stringWithFormat:@"%@ \nazimuth:  %.1f deg\ndistance: %.0f m\ntime: %.0f sec\nTurnAngle: %.0f deg",
                     [instruction getStreetName],
                     [instruction getAzimuth],
                     [instruction getDistance],
                     [instruction getTime],
                     [instruction getTurnAngle]
                     ];

    // filter out some instructions which would be too noisy for the map
    if([str isEqualToString:@"continue"] or [str isEqualToString:@"enter roundabout"]) {
        return nil;
    }
    
    
    NTMarker* marker = [[NTMarker alloc] initWithPos:pos style:style];
    
    [marker setMetaDataElement:@"desc" element:[[NTVariant alloc] initWithString:desc]];
    [marker setMetaDataElement:@"title" element:[[NTVariant alloc] initWithString:str]];
    
    // Do not toast every instruction, uncomment if you wish to see all of them.
    //[self alert:[NSString stringWithFormat:@"Instruction: %@ (%@)", str, desc]];
    
    return marker;
}

-(NTLine*) calculateRouteLine: (NTRoutingResult*) result{
 
    // style for the line
    NTLineStyleBuilder* lineStyleBuilder = [[NTLineStyleBuilder alloc] init];
    [lineStyleBuilder setColor:[[NTColor alloc] initWithColor:0xFF888888]];
    [lineStyleBuilder setWidth:12];
    
    return [[NTLine alloc] initWithPoses:[result getPoints] style:[lineStyleBuilder buildStyle]];

}

@end

@implementation RouteClickListener

-(void)setVectorDataSource:(NTLocalVectorDataSource*)vectorDataSource
{
    _routeDataSource = vectorDataSource;
}

-(void)onMapMoved
{
    // do nothing
}

-(void)onMapClicked:(NTMapClickInfo*)mapClickInfo
{
    // set start and end pos
    
    // Remove old click label
    if (_oldClickLabel)
    {
        [_routeDataSource remove:_oldClickLabel];
        _oldClickLabel = nil;
    }
    
    if ([mapClickInfo getClickType] == NT_CLICK_TYPE_LONG) {
        
        NTMapPos* clickPos = [mapClickInfo getClickPos];
        
        if(_startPos == nil){
            _startPos = clickPos;
            [(OfflineRoutingController*)_routingController setStart: clickPos];
            
        }else if (_stopPos == nil){
            
            _stopPos = clickPos;
            
            [(OfflineRoutingController*)_routingController setStop: clickPos];
            
            // restart to force new route next time
            _startPos = nil;
            _stopPos = nil;
        }
    }
}

-(void)onVectorElementClicked:(NTVectorElementClickInfo*)clickInfo
{
    // Remove old click label
    if (_oldClickLabel)
    {
        [_routeDataSource remove:_oldClickLabel];
        _oldClickLabel = nil;
    }
    
    // Check the type of vector element
    NTVectorElement* vectorElement = [clickInfo getVectorElement];
    
    NSString* desc = [[vectorElement getMetaDataElement:@"desc"] getString];
    NSString* title = [[vectorElement getMetaDataElement:@"title"] getString];
    
    if([desc isEqualToString:@""]) {
        return;
    }

    NTBalloonPopup* clickPopup = [[NTBalloonPopup alloc] init];
    NTBalloonPopupStyleBuilder* styleBuilder = [[NTBalloonPopupStyleBuilder alloc] init];
    
    [styleBuilder setPlacementPriority: 1]; // make sure it is on top of Markers
    
    if([title isEqualToString:@""]){
        // route description if clicked to line
        [styleBuilder setLeftColor:[[NTColor alloc] initWithColor:0xFF0000AA]]; // blue
        
        clickPopup = [[NTBalloonPopup alloc] initWithPos:[clickInfo getElementClickPos] style:[styleBuilder buildStyle] title:desc desc:@""];
    } else {
        [styleBuilder setLeftColor:[[NTColor alloc] initWithColor:0xFF00AA00]]; // green

        NTVectorElement* vectorElement = [clickInfo getVectorElement];
        
        if([vectorElement isKindOfClass:[NTBillboard class]]) {
            
            NTBillboard* billboard = (NTBillboard*)vectorElement;

            clickPopup = [[NTBalloonPopup alloc] initWithBaseBillboard:billboard style:[styleBuilder buildStyle] title:title desc:desc];
        }

        
    }
    
    [_routeDataSource add:clickPopup];
    _oldClickLabel = clickPopup;
}

@end

@implementation RoutePackageManagerListener

- (void)getPackage:(NSString *)package
{
    NTPackageStatus* status = [_packageManager getLocalPackageStatus: package version:-1];
    
    if (status == nil) {
        [_packageManager startPackageDownload: package];
    } else if ([status getCurrentAction] == NT_PACKAGE_ACTION_READY) {
        
        [(OfflineRoutingController*)_routingController setOfflinePackageReady: true];
        
        [(OfflineRoutingController*)self.routingController alert:[NSString stringWithFormat:@"Routing package %@ downloaded", package ]];
    }
}

- (void)onPackageListUpdated
{
    NSLog(@"onPackageListUpdated");
    // We have packages all country/regions
    // You can download several packages, and route is found through all of them
    
    [self getPackage:@"EE-routing"];
    [self getPackage:@"LV-routing"];
    [self getPackage:@"LT-routing"];
}

- (void)onPackageListFailed
{
    NSLog(@"onPackageListFailed");
}

- (void)onPackageUpdated:(NSString*)packageId version:(int)version
{
}

- (void)onPackageCancelled:(NSString*)packageId version:(int)version
{
}

- (void)onPackageFailed:(NSString*)packageId version:(int)version errorType:(enum NTPackageErrorType)errorType
{
    NSLog(@"onPackageFailed");
}

- (void)onPackageStatusChanged:(NSString*)packageId version:(int)version status:(NTPackageStatus*)status
{
    NSLog(@"onPackageStatusChanged progress: %f", [status getProgress]);
}

@end








