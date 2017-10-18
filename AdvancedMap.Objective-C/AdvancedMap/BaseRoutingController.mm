
#import "BaseRoutingController.h"

@implementation BaseRoutingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentView = [[PackageDownloadBaseView alloc] init];
    self.view = self.contentView;
    
    [self.contentView addDefaultBaseLayer];
    
    // Get the base projection set in the base class
    NTProjection* proj = [[self.contentView.mapView getOptions] getBaseProjection];
    
    // Initialize an online vector data source for base map
    _routeDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
    _routeStartStopDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
    
    // Initialize a vector layer with the previous data source
    NTVectorLayer* vectorLayer = [[NTVectorLayer alloc] initWithDataSource:_routeDataSource];
    NTVectorLayer* vectorLayerStartStop = [[NTVectorLayer alloc] initWithDataSource:_routeStartStopDataSource];
    
    // Add the previous vector layer to the map
    [[self.contentView.mapView getLayers] add:vectorLayer];
    [[self.contentView.mapView getLayers] add:vectorLayerStartStop];
    
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.contentView.mapView setMapEventListener:self.mapListener];
    
//    [self alert:@"Long click on the map to set the start and end position"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.contentView.mapView setMapEventListener:nil];

    [self.mapListener setRoutingController:nil];
    [self.mapListener setRouteDataSource:nil];
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
    
    NTProjection *projection = [[self.contentView.mapView getOptions] getBaseProjection];
    NTRoutingRequest* request = [[NTRoutingRequest alloc] initWithProjection:projection points:poses];
    
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    // Calculation should be in background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NTRoutingResult* route = [self.service calculateRoute:request];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSTimeInterval duration = [NSDate timeIntervalSinceReferenceDate] - start;
            
            if (route == nil) {
//                [self alert:@"route error"];
                return;
            }
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            
            NSString* routeDesc = [NSString stringWithFormat:@"Route: %0.3f km, travel %@. Calculation took %0.3f s", [route getTotalDistance]/1000.0, [dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:[route getTotalTime]]], duration];
            
//            [self alert:[NSString stringWithFormat:@"%@",routeDesc]];
            
            // Show line
            NTLine* routeLine = [self calculateRouteLine: route];
            
            [routeLine setMetaDataElement:@"desc" element:[[NTVariant alloc] initWithString:routeDesc]];
            
            [_routeDataSource add: routeLine];
            
            // Show instructions as popups
            NTRoutingInstructionVector* instructions = [route getInstructions];
            NTMapPosVector* points = [route getPoints];
            for (int i = 0; i < [instructions size]; i++) {
                NTRoutingInstruction *instruction = [instructions get:i];
                NTMarker* popup = [self createRoutePoint: instruction point: [points get:[instruction getPointIndex]]];
                
                if (popup != nil) {
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
    
    NSString* desc = [NSString stringWithFormat:@"%@ \nazimuth:  %.1f deg\ndistance: %.0f m\ntime: %.0f sec\nTurnAngle: %.0f deg", [instruction getStreetName], [instruction getAzimuth], [instruction getDistance], [instruction getTime], [instruction getTurnAngle]];
    
    // Filter out some instructions which would be too noisy for the map
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

-(NTLine*) calculateRouteLine: (NTRoutingResult*) result
{
    // Style for the line
    NTLineStyleBuilder* lineStyleBuilder = [[NTLineStyleBuilder alloc] init];
    [lineStyleBuilder setColor:[[NTColor alloc] initWithColor:0xFF888888]];
    [lineStyleBuilder setWidth:12];
    
    return [[NTLine alloc] initWithPoses:[result getPoints] style:[lineStyleBuilder buildStyle]];
}

@end





















