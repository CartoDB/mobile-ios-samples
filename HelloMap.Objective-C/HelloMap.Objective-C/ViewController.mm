//
//  ViewController.mm
//  HelloMap.Objective-C
//
//  Created by Aare Undo on 01/09/16.
//  Copyright © 2016 Aare Undo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@interface HelloMapListener : NTMapEventListener

@property NTLocalVectorDataSource* vectorDataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Minimal map definition code follows with some tweaks
    
    // Smoother UI/animations
    [self setPreferredFramesPerSecond:60];

    // The storyboard has NTMapView connected as a view
    NTMapView* mapView = (NTMapView*) self.view;
    
    // Set common map view options. Use EPSG4326 projection for coordinates. This allows us to use longitude/latitude coordinates directly.
    NTProjection* proj = [[NTEPSG4326 alloc] init];
    [[mapView getOptions] setBaseProjection:proj];
    [[mapView getOptions] setZoomGestures:YES]; // enable zooming on clicks/double clicks
    [[mapView getOptions] setRenderProjectionMode:NT_RENDER_PROJECTION_MODE_SPHERICAL]; // comment this line to switch to default planar mode

    // Add base layer
    NTVectorTileLayer* baseLayer = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_POSITRON];
    [[mapView getLayers] add:baseLayer];
    
    // Animate zoom to Tallinn, Estonia
    NTMapPos* tallinn = [[NTMapPos alloc] initWithX:24.646469 y:59.426939];
    [mapView setFocusPos:tallinn durationSeconds:0];
    [mapView setRotation:0 durationSeconds:0];
    [mapView setZoom:3 durationSeconds:0];
    [mapView setZoom:4 durationSeconds:2];

    // Initialize a local vector data source
    NTLocalVectorDataSource* vectorDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
    
    // Initialize a vector layer with the previous data source
    NTVectorLayer* vectorLayer = [[NTVectorLayer alloc] initWithDataSource:vectorDataSource];
    
    // Add the previous vector layer to the map
    [[mapView getLayers] add:vectorLayer];
    
    // Create a marker style
    NTMarkerStyleBuilder* markerStyleBuilder = [[NTMarkerStyleBuilder alloc] init];
    [markerStyleBuilder setSize:15];
    NTColor* color = [[NTColor alloc] initWithR:242 g:68 b:64 a:255];
    [markerStyleBuilder setColor:color];
    
    NTMarkerStyle* markerStyle = [markerStyleBuilder buildStyle];
    
    // Define position and add the marker to the Datasource (which is already in a Layer and MapView)
    NTMarker* marker = [[NTMarker alloc] initWithPos:tallinn style:markerStyle];
    [vectorDataSource add:marker];
    
    // Add simple event listener that changes size and/or color on map click
    HelloMapListener* listener = [[HelloMapListener alloc] init];
    listener.vectorDataSource = vectorDataSource;
    [mapView setMapEventListener: listener];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // The storyboard has NTMapView connected as a view
    NTMapView* mapView = (NTMapView*) self.view;

    // Disconnect all listeners at this point to avoid leaks
    [mapView setMapEventListener:nil];
}

@end


@implementation HelloMapListener

-(void) onMapClicked:(NTMapClickInfo *)mapClickInfo {
    // Create a new marker at the clicked position. Use random properties.
    NTMarkerStyleBuilder* markerStyleBuilder = [[NTMarkerStyleBuilder alloc] init];
    
    int size = arc4random_uniform(20) + 10;
    [markerStyleBuilder setSize:size];
    
    NSArray* colors = @[
        [[NTColor alloc]initWithR:255 g:255 b:255 a:255],
        [[NTColor alloc]initWithR:0 g:0 b:255 a:255],
        [[NTColor alloc]initWithR:255 g:0 b:0 a:255],
        [[NTColor alloc]initWithR:0 g:255 b:0 a:255],
        [[NTColor alloc]initWithR:200 g:120 b:0 a:255]
    ];
    NTColor* color = [colors objectAtIndex:arc4random_uniform((int)[colors count])];
    [markerStyleBuilder setColor:color];
    
    NTMarkerStyle* markerStyle = [markerStyleBuilder buildStyle];
    NTMarker* marker = [[NTMarker alloc] initWithPos:[mapClickInfo getClickPos] style:markerStyle];
    [self.vectorDataSource add:marker];
}

@end
