//
//  IndoorRoutingController.mm
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 01/09/16.
//  Copyright © 2016 Aare Undo. All rights reserved.
//

#import "MapBaseController.h"

#define FLOOR_HEIGHT 10

@interface MapClickListener : NTMapEventListener

@property (strong, nonatomic) NTMapView* mapView;
@property (strong, nonatomic) UIViewController* routingController;

@property (strong, nonatomic) NTMapPos* startPos;
@property (strong, nonatomic) NTMapPos* stopPos;

@end

@interface VectorElementClickListener : NTVectorElementEventListener

@property (strong, nonatomic) NTMapView* mapView;
@property (strong, nonatomic) UIViewController* routingController;

@property (strong, nonatomic) NTBalloonPopup* oldClickLabel;

@end

@interface IndoorRoutingController : MapBaseController

@property NTMapView* mapView;
@property NTRoutingService* service;

@property MapClickListener* mapListener;
@property VectorElementClickListener* vectorElementListener;

@property int selectedFloor;
@property NSArray* floorLayers;
@property NSArray* routeLayers;

@property NTMapPos* startPos;
@property NTMapPos* stopPos;

@property NTMarker* startMarker;
@property NTMarker* stopMarker;

@property NTMarkerStyle* instructionUp;
@property NTMarkerStyle* instructionDown;
@property NTMarkerStyle* instructionLeft;
@property NTMarkerStyle* instructionRight;

-(void) setStart:(NTMapPos*)mapPos;
-(void) setStop:(NTMapPos*)mapPos;

@end

@implementation IndoorRoutingController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    // The storyboard has NTMapView connected as a view
    NTMapView* mapView = (NTMapView*)self.contentView.mapView;
    self.mapView = mapView;
 
    [[mapView getOptions] setClickTypeDetection:YES];
    NTProjection* proj = [[self.mapView getOptions] getBaseProjection];
    
    // Create a map event listener
    self.mapListener = [[MapClickListener alloc] init];
    [self.mapListener setRoutingController: self];
    [mapView setMapEventListener: self.mapListener];
    
    self.vectorElementListener = [[VectorElementClickListener alloc] init];
    [self.vectorElementListener setRoutingController:self];
    
    // Add base layer
    NTVectorTileLayer* baseLayer = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_VOYAGER];
    [[mapView getLayers] add:baseLayer];

    // Initialize markers
    [self createMarkers];

    // Initialize floors, find portals
    NSMutableArray* floorLayers = [[NSMutableArray alloc] init];
    NSMutableArray* routeLayers = [[NSMutableArray alloc] init];

    NSArray* floors = @[@"floor0", @"floor1"];
    for (int level = 0; level < [floors count]; level++) {
        NTVariant* floorGeoJSON = [self loadGeoJSON: floors[level]];

        NTVectorLayer* floorLayer = [self createFloorLayer: floorGeoJSON level:level];
        [floorLayers addObject: floorLayer];

        NTVectorLayer* routeLayer = [self createRouteLayer];
        [routeLayers addObject: routeLayer];

        // Add floor selection button
        PopupButton* button = [[PopupButton alloc] initWithImageUrl:[NSString stringWithFormat:@"icon_%d.png", level+1]];
        [self.contentView addRecognizer:self view:button action:@selector(floorButtonClicked:)];
        button.tag = level;
        [self.contentView addButton:button];
    }

    self.floorLayers = [floorLayers copy];
    self.routeLayers = [routeLayers copy];

    // Create routing service
    NSString* configPath = [[NSBundle mainBundle] pathForResource:@"sgreconfig" ofType:@"json"];
    NSString* configString = [NSString stringWithContentsOfFile:configPath encoding:NSUTF8StringEncoding error:nil];
    NTVariant* config = [NTVariant fromString:configString];

    NTVariant* routingGeoJSON = [self loadGeoJSON:@"floors_routing"];
    self.service = [[NTSGREOfflineRoutingService alloc] initWithGeoJSON:routingGeoJSON config:config];
    
    // Select floor 0 and create UI
    [self selectFloor:0];

    // Zoom-in
    [mapView setFocusPos:[proj fromLat: 58.366 lng:26.744] durationSeconds:0];
    [mapView setZoom: 15.5f durationSeconds:0.0f];
    [mapView setZoom: 16.0f durationSeconds:1.0f];
}

-(NTVariant*) loadGeoJSON:(NSString*)name {
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"geojson"];
    NSString* geoJSONString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return [NTVariant fromString:geoJSONString];
}

-(void) createMarkers {
    // Create markers for start and end
    NTMarkerStyleBuilder* markerStyleBuilder = [[NTMarkerStyleBuilder alloc] init];
    [markerStyleBuilder setSize:30];
    [markerStyleBuilder setHideIfOverlapped:NO];
    [markerStyleBuilder setColor:[[NTColor alloc] initWithColor:0xFF00FF00]]; // Green
    
    // Initial empty markers
    _startMarker = [[NTMarker alloc] initWithPos:[[NTMapPos alloc] initWithX:0 y:0] style:[markerStyleBuilder buildStyle]];
    
    // Change color to Red
    [markerStyleBuilder setColor:[[NTColor alloc] initWithColor:0xFFFF0000]];
    
    _stopMarker = [[NTMarker alloc] initWithPos:[[NTMapPos alloc] initWithX:0 y:0] style:[markerStyleBuilder buildStyle]];
    
    // Create styles for instruction markers
    [markerStyleBuilder setColor: [[NTColor alloc] initWithColor:0xFFFFFFFF]]; // white
    [markerStyleBuilder setBitmap:[NTBitmapUtils createBitmapFromUIImage:[UIImage imageNamed:@"direction_up.png"]]];
    _instructionUp = [markerStyleBuilder buildStyle];
    
    [markerStyleBuilder setBitmap:[NTBitmapUtils createBitmapFromUIImage:[UIImage imageNamed:@"direction_down.png"]]];
    _instructionDown = [markerStyleBuilder buildStyle];
 
    [markerStyleBuilder setBitmap:[NTBitmapUtils createBitmapFromUIImage:[UIImage imageNamed:@"direction_upthenleft.png"]]];
    _instructionLeft = [markerStyleBuilder buildStyle];
    
    [markerStyleBuilder setBitmap:[NTBitmapUtils createBitmapFromUIImage:[UIImage imageNamed:@"direction_upthenright.png"]]];
    _instructionRight = [markerStyleBuilder buildStyle];
}

-(void) selectFloor:(int)level {
    for (int i = 0; i < [self.floorLayers count]; i++) {
        BOOL visible = (i == level);
        [self.floorLayers[i] setVisible:visible];
        [self.routeLayers[i] setVisible:visible];
    }
    self.selectedFloor = level;
}

-(NTVectorLayer*) createFloorLayer:(NTVariant*)geojson level:(int)level {
    NTProjection* proj = [[self.mapView getOptions] getBaseProjection];

    // Load feature collection
    NTGeoJSONGeometryReader* reader = [[NTGeoJSONGeometryReader alloc] init];
    [reader setTargetProjection:proj];
    NTFeatureCollection* collection = [reader readFeatureCollection:[geojson description]];

    // Initialize style
    NTGeometryCollectionStyleBuilder* builder = [[NTGeometryCollectionStyleBuilder alloc] init];
    NTPointStyleBuilder* pointStyleBuilder = [[NTPointStyleBuilder alloc] init];
    [pointStyleBuilder setColor:[[NTColor alloc] initWithR:0 g:level*80 b:255-level*80 a:255]];
    [pointStyleBuilder setSize:5.0f];
    [builder setPointStyle:[pointStyleBuilder buildStyle]];
    NTLineStyleBuilder* lineStyleBuilder = [[NTLineStyleBuilder alloc] init];
    [lineStyleBuilder setColor:[[NTColor alloc] initWithR:0 g:level*80 b:255-level*80 a:255]];
    [lineStyleBuilder setWidth:3.0f];
    [builder setLineStyle:[lineStyleBuilder buildStyle]];
    NTPolygonStyleBuilder* polygonStyleBuilder = [[NTPolygonStyleBuilder alloc] init];
    [polygonStyleBuilder setColor:[[NTColor alloc] initWithR:0 g:level*80 b:255-level*80 a:128]];
    [polygonStyleBuilder setLineStyle:[lineStyleBuilder buildStyle]];
    [builder setPolygonStyle:[polygonStyleBuilder buildStyle]];

    // Create data source and layer
    NTLocalVectorDataSource* dataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
    NTVectorLayer* vectorLayer = [[NTVectorLayer alloc] initWithDataSource:dataSource];
    [dataSource addFeatureCollection:collection style:[builder buildStyle]];
    
    // Add listener
    [vectorLayer setVectorElementEventListener:self.vectorElementListener];
    
    // Add the previous vector layer to the map
    [[self.mapView getLayers] add:vectorLayer];

    return vectorLayer;
}

-(NTVectorLayer*) createRouteLayer {
    NTProjection* proj = [[self.mapView getOptions] getBaseProjection];

    // Create data source and vector layer
    NTLocalVectorDataSource* dataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
    NTVectorLayer* vectorLayer = [[NTVectorLayer alloc] initWithDataSource:dataSource];

    // Add the previous vector layer to the map
    [[self.mapView getLayers] add:vectorLayer];
    
    return vectorLayer;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.contentView.banner showInformationWithText:@"Long Click on the floorplan to set route positions. There are 2 connected floors." autoclose:YES];

    [self.mapView setMapEventListener:self.mapListener];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.mapView setMapEventListener:nil];

    [self.mapListener setRoutingController:nil];
}

-(void) floorButtonClicked:(UITapGestureRecognizer *)recognizer {
    int level = recognizer.view.tag;
    [self selectFloor: level];
}

-(void) setStart:(NTMapPos*)mapPos {
    for (NTVectorLayer* routeLayer in self.routeLayers) {
        NTLocalVectorDataSource* routeDataSource = (NTLocalVectorDataSource*)[routeLayer getDataSource];
        [routeDataSource clear];
    }
    self.startPos = [[NTMapPos alloc] initWithX:[mapPos getX] y:[mapPos getY] z:self.selectedFloor*FLOOR_HEIGHT];
    [_startMarker setPos:mapPos];
    
    NTLocalVectorDataSource* routeDataSource = (NTLocalVectorDataSource*)[self.routeLayers[self.selectedFloor] getDataSource];
    [routeDataSource add:_startMarker];
}

-(void) setStop:(NTMapPos*)mapPos {
    self.stopPos = [[NTMapPos alloc] initWithX:[mapPos getX] y:[mapPos getY] z:self.selectedFloor*FLOOR_HEIGHT];
    [_stopMarker setPos:mapPos];
    NTLocalVectorDataSource* routeDataSource = (NTLocalVectorDataSource*)[self.routeLayers[self.selectedFloor] getDataSource];
    [routeDataSource add:_stopMarker];
    [self showRoute: self.startPos stopPos:self.stopPos];
}

// Calculate route, show on map
-(void) showRoute: (NTMapPos*)startPos stopPos:(NTMapPos*)stopPos {
    NTMapPosVector* poses = [[NTMapPosVector alloc] init];
    [poses add:startPos];
    [poses add:stopPos];
    
    NTProjection* proj = [[self.mapView getOptions] getBaseProjection];
    NTRoutingRequest* request = [[NTRoutingRequest alloc] initWithProjection:proj points:poses];
    
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    // Calculation should be in background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NTRoutingResult* route;
        @try {
            route = [self.service calculateRoute:request];
        } @catch (NSException* exception) {
            NSLog(@"Routing failed: %@", exception);
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSTimeInterval duration = [NSDate timeIntervalSinceReferenceDate] - start;
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            
            NSString* routeDesc = [NSString stringWithFormat:@"Route: %0.3f km, travel %@. Calculation took %0.3f s", [route getTotalDistance]/1000.0, [dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:[route getTotalTime]]], duration];
            NSLog(@"%@", routeDesc);
            
            NTRoutingInstructionVector* instructions = [route getInstructions];
            NTMapPosVector* points = [route getPoints];
            
            // Show line
            NTLineStyleBuilder* lineStyleBuilder = [[NTLineStyleBuilder alloc] init];
            [lineStyleBuilder setColor:[[NTColor alloc] initWithColor:0xFF888888]];
            [lineStyleBuilder setWidth:12];
            NTLineStyle* lineStyle = [lineStyleBuilder buildStyle];

            int i0 = 0, i1 = 0;
            for (; i1 <= [points size]; i1++) {
                int level0 = (int) ([[points get:i0] getZ] / FLOOR_HEIGHT);
                int level1 = (i1 < [points size] ? (int) ([[points get:i1] getZ] / FLOOR_HEIGHT) : -1);
                if (level0 != level1) {
                    NTMapPosVector* routePoses = [[NTMapPosVector alloc] init];
                    for (int i = i0; i < i1; i++) {
                        NTMapPos* mapPos3D = [points get:i];
                        [routePoses add:[[NTMapPos alloc] initWithX:[mapPos3D getX] y:[mapPos3D getY] z:0]];
                    }
                    NTLine* routeLine = [[NTLine alloc] initWithPoses:routePoses style:lineStyle];

                    NTLocalVectorDataSource* dataSource = (NTLocalVectorDataSource*)[self.routeLayers[level0] getDataSource];
                    [dataSource add:routeLine];

                    i0 = i1;
                }
            }
            
            // Show instructions as popups
            for (int i = 0; i < [instructions size]; i++) {
                NTRoutingInstruction* instruction = [instructions get:i];
                NTMapPos* mapPos3D = [points get:i];
                NTMapPos* mapPos = [[NTMapPos alloc] initWithX:[mapPos3D getX] y:[mapPos3D getY] z:0];
                int level = (int)([mapPos3D getZ] / FLOOR_HEIGHT);
                
                NSString* streetName = [instruction getStreetName];
                NTVariant* tag = [NTVariant fromString: streetName];
                
                NSLog(@"Instruction: %@, tag: %@", instruction, tag);

                NTMarker* popup = [self createRoutePoint: instruction point:mapPos];
                
                if (popup != nil) {
                    NTLocalVectorDataSource* dataSource = (NTLocalVectorDataSource*)[self.routeLayers[level] getDataSource];
                    [dataSource add:popup];
                }
            }
        });
    });
}

-(NTMarker*) createRoutePoint: (NTRoutingInstruction*) instruction point:(NTMapPos*) pos {
    NTMarkerStyle* style = nil;
    NSString* str = @"";
    
    switch ([instruction getAction]) {
        case NT_ROUTING_ACTION_WAIT:
            str = @"wait";
            break;
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
        case NT_ROUTING_ACTION_GO_UP:
            style = _instructionUp;
            str = @"go up";
            break;
        case NT_ROUTING_ACTION_GO_DOWN:
            style = _instructionDown;
            str = @"go up";
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
    
    if (style == nil) {
        return nil;
    }
    
    NSString* desc = [NSString stringWithFormat:@"%@ \nazimuth:  %.1f deg\ndistance: %.0f m\ntime: %.0f sec\nTurnAngle: %.0f deg", [instruction getStreetName], [instruction getAzimuth], [instruction getDistance], [instruction getTime], [instruction getTurnAngle]];
    
    NTMarker* marker = [[NTMarker alloc] initWithPos:pos style:style];
    
    [marker setMetaDataElement:@"desc" element:[[NTVariant alloc] initWithString:desc]];
    [marker setMetaDataElement:@"title" element:[[NTVariant alloc] initWithString:str]];
    
    return marker;
}

@end

// RouteClickListener handles all user interaction - setting start/end markers, property popups, etc

@implementation MapClickListener

-(void)onMapMoved {
    // do nothing
}

-(void)onMapClicked:(NTMapClickInfo*)mapClickInfo {
    if ([mapClickInfo getClickType] == NT_CLICK_TYPE_LONG) {
        
        NTMapPos* clickPos = [mapClickInfo getClickPos];
        
        if(_startPos == nil) {
            _startPos = clickPos;
            [(IndoorRoutingController*)self.routingController setStart: clickPos];
            
        } else if (_stopPos == nil) {
            
            _stopPos = clickPos;
            
            [(IndoorRoutingController*)self.routingController setStop: clickPos];
            
            // restart to force new route next time
            _startPos = nil;
            _stopPos = nil;
        }
    }
}

@end

@implementation VectorElementClickListener

-(BOOL)onVectorElementClicked:(NTVectorElementClickInfo*)clickInfo {
    if ([clickInfo getClickType] == NT_CLICK_TYPE_LONG) {
        return NO;
    }

    // Remove old click label
    if (_oldClickLabel) {
//        [_routeDataSource remove:_oldClickLabel];
        _oldClickLabel = nil;
    }
    
    // Check the type of vector element
    NTVectorElement* vectorElement = [clickInfo getVectorElement];

    NTStringVariantMap* metaDataMap = [vectorElement getMetaData];
    NSString* desc = @"";
    for (int i = 0; i < [metaDataMap size]; i++) {
        NSString* key = [metaDataMap get_key:i];
        desc = [NSString stringWithFormat:@"%@%@=%@\n", desc, key, [metaDataMap get:key]];
    }
    if ([desc isEqualToString:@""]) {
        return YES;
    }
    
    NTBalloonPopup* clickPopup = [[NTBalloonPopup alloc] init];
    NTBalloonPopupStyleBuilder* popupStyleBuilder = [[NTBalloonPopupStyleBuilder alloc] init];
    
    [popupStyleBuilder setPlacementPriority: 1]; // make sure it is on top of Markers
    
    // route description if clicked to line
    [popupStyleBuilder setLeftColor:[[NTColor alloc] initWithColor:0xFF0000AA]]; // blue
        
    clickPopup = [[NTBalloonPopup alloc] initWithPos:[clickInfo getElementClickPos] style:[popupStyleBuilder buildStyle] title:desc desc:@""];
    
  //  [_routeDataSource add:clickPopup];
    _oldClickLabel = clickPopup;

    return YES;
}

@end
