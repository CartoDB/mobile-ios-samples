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

@property NTMarker* marker;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // minimal map definition code
    
    // The storyboard has NTMapView connected as a view
    NTMapView* mapView = (NTMapView*) self.view;
    
    // Add base layer
    NTVectorTileLayer* layer = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_DEFAULT];
    [[mapView getLayers] add:layer];
    
    NTProjection* proj = [[mapView getOptions] getBaseProjection];
    
    // Animate zoom to Tallinn, Estonia
    NTMapPos* tallinn = [proj fromWgs84:[[NTMapPos alloc] initWithX:24.646469 y:59.426939]];
    [mapView setZoom:3 durationSeconds:2];
    [mapView setFocusPos:tallinn durationSeconds:0];
    
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
    
    NTMarkerStyle* sharedMarkerStyle = [markerStyleBuilder buildStyle];
    
    // Define position and add the marker to the Datasource (which is already in a Layer and MapView)
    NTMarker* marker = [[NTMarker alloc] initWithPos:tallinn style:sharedMarkerStyle];
    [vectorDataSource add:marker];
    
    // Add simple event listener that changes size and/or color on map click
    HelloMapListener* listener = [[HelloMapListener alloc]init];
    listener.marker = marker;
    [mapView setMapEventListener: listener];
}

@end


@implementation HelloMapListener

-(void) onMapClicked:(NTMapClickInfo *)mapClickInfo
{
    NTMarkerStyleBuilder* builder = [[NTMarkerStyleBuilder alloc] init];
    
    int size = arc4random_uniform(50);
    [builder setSize:size];
    
    NSArray* colors = [self getColors];
    
    NTColor* color = [colors objectAtIndex:arc4random_uniform((int)[colors count])];
    [builder setColor:color];
    
    [self.marker setStyle:builder.buildStyle];
}

-(NSArray*) getColors
{
    return @[
             [[NTColor alloc]initWithR:255 g:255 b:255 a:255],
             [[NTColor alloc]initWithR:0 g:0 b:255 a:255],
             [[NTColor alloc]initWithR:255 g:0 b:0 a:255],
             [[NTColor alloc]initWithR:0 g:255 b:0 a:255],
             [[NTColor alloc]initWithR:0 g:0 b:0 a:255]
             ];
}

@end









