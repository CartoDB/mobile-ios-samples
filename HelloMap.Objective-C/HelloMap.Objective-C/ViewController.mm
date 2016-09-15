//
//  ViewController.mm
//  HelloMap.Objective-C
//
//  Created by Aare Undo on 01/09/16.
//  Copyright © 2016 Aare Undo. All rights reserved.
//

#import "ViewController.h"
#import "MyCartoVisBuilder.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // minimal map definition code
    
    // The storyboard has NTMapView connected as a view
    NTMapView* mapView = (NTMapView*) self.view;
    
    // Add vector tile layer
    NTVectorTileLayer* layer = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_DEFAULT];
    [[mapView getLayers] add:layer];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Initialize a local vector data source
        NTProjection* proj = [[mapView getOptions] getBaseProjection];
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
        NTMapPos* tallinn = [proj fromWgs84:[[NTMapPos alloc] initWithX:24.646469 y:59.426939]];
        NTMarker* marker = [[NTMarker alloc] initWithPos:tallinn style:sharedMarkerStyle];
        
        [vectorDataSource add:marker];
        
        // Animate zoom
        [mapView setZoom:3 durationSeconds:2];
        [mapView setFocusPos:tallinn durationSeconds:0];
    });
}

@end

/*
 * CARTO Vis Builder
 */

@implementation MyCartoVisBuilder

// methods to set map center and zoom based on defined map
-(void)setCenter:(NTMapPos *)mapPos
{
    [self.mapView setFocusPos:[[[self.mapView getOptions] getBaseProjection] fromWgs84:mapPos] durationSeconds:1.0f];
}

-(void)setZoom:(float)zoom
{
    [self.mapView setZoom:zoom durationSeconds:1.0f];
}

// Add a layer to the map view
-(void)addLayer:(NTLayer *)layer attributes:(NTVariant *)attributes
{
    [[self.mapView getLayers] add:layer];
}

@end









