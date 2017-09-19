
#import "BaseRoutingController.h"

@implementation BaseRoutingController

- (BaseRoutingView *) getRoutingView {
    return (BaseRoutingView *)self.contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentView = [[BaseRoutingView alloc] init];
    self.view = self.contentView;
    
    [self.contentView addDefaultBaseLayer];

    // Create a map event listener
    self.mapListener = [[RouteClickListener alloc] init];
    
    // MapEventListener needs the data source and the layer to display balloons over the clicked vector elements
    [self.mapListener setRoutingController: self];
    [self.mapListener setRouteDataSource:[self getRoutingView].routeDataSource];
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
}

-(void)setStart:(NTMapPos *)mapPos
{
    [[self getRoutingView] setStart:mapPos];
}

-(void)setStop:(NTMapPos *)mapPos
{
    [[self getRoutingView] setStop:mapPos];
    
    NTMapPos *startPos = [[[self getRoutingView].startMarker getGeometry] getCenterPos];
    NTMapPos *stopPos = [[[self getRoutingView].stopMarker getGeometry] getCenterPos];
    
    [self showRoute: startPos stopPos: stopPos];
}

// Calculate route, show on map
-(void)showRoute: (NTMapPos *)startPos stopPos:(NTMapPos *)stopPos
{
    NTMapPosVector* poses = [[NTMapPosVector alloc] init];
    [poses add:startPos];
    [poses add:stopPos];
    
    NTProjection *projection = [[self.contentView.mapView getOptions] getBaseProjection];
    NTRoutingRequest* request = [[NTRoutingRequest alloc] initWithProjection:projection points:poses];
    
    // Calculation should be in background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NTRoutingResult* route = [self.service calculateRoute:request];
        
        if (route == nil) {
            NSString *text = @"Error calculating route";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.contentView.banner showInformationWithText:text autoclose:true];
            });
            
            return;
        }
            
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            
        NSString* routeDesc = [NSString stringWithFormat:@"Route: %0.3f km, travel %@", [route getTotalDistance]/1000.0, [dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:[route getTotalTime]]]];
        [self.contentView.banner showInformationWithText:routeDesc autoclose:true];
            
        // Show line
        NTLine* routeLine = [[self getRoutingView] calculateRouteLine: route];
        [[self getRoutingView].routeDataSource add: routeLine];
            
        // Show instructions as popups
        NTRoutingInstructionVector* instructions = [route getInstructions];
        NTMapPosVector* points = [route getPoints];
            
        for (int i = 0; i < [instructions size]; i++) {
            NTRoutingInstruction *instruction = [instructions get:i];
            NTMarker* popup = [[self getRoutingView] createRoutePoint: instruction point: [points get:[instruction getPointIndex]]];
                
            if (popup != nil) {
                [[self getRoutingView].routeDataSource add:popup];
            }
        }
        
    });
}

@end





















