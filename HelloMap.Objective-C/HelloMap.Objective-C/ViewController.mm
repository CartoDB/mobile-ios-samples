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

- (void)loadView {
    // The initial step: register your license.
    // This must be done before using MapView
    [NTMapView registerLicense:@"YOUR_LICENSE_KEY"];
    [super loadView];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // minimal map definition code
    
    // The storyboard has NTMapView connected as a view
    NTMapView* mapView = (NTMapView*) self.view;
    
    // Add vector tile layer
    NTVectorTileLayer* layer = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_DEFAULT];
    [[mapView getLayers] add:layer];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Make sure no other layers are on map
        [[mapView getLayers] clear];
        
        // Create VIS loader
        NTCartoVisLoader* loader = [[NTCartoVisLoader alloc] init];
        
        // Load fonts package, this has all fonts you may need.
        [loader setVectorTileAssetPackage:[[NTZippedAssetPackage alloc] initWithZipData:[NTAssetUtils loadAsset:@"carto-fonts.zip"]]];
        [loader setDefaultVectorLayerMode:YES];
        MyCartoVisBuilder* visBuilder = [[MyCartoVisBuilder alloc] init];
        visBuilder.mapView = mapView;
        
        // Use your Map URL in next line, you get it from Share Map page. Here is a basic working sample:
        [loader loadVis:visBuilder visURL:@"http://documentation.carto.com/api/v2/viz/2b13c956-e7c1-11e2-806b-5404a6a683d5/viz.json"];
        
        // Initialize a local vector data source
        NTProjection* proj = [[mapView getOptions] getBaseProjection];
        NTLocalVectorDataSource* vectorDataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
        
        // Initialize a vector layer with the previous data source
        NTVectorLayer* vectorLayer = [[NTVectorLayer alloc] initWithDataSource:vectorDataSource];
        
        // Add the previous vector layer to the map
        [[mapView getLayers] add:vectorLayer];
        
        // Create a marker style
        NTMarkerStyleBuilder* markerStyleBuilder = [[NTMarkerStyleBuilder alloc] init];
        [markerStyleBuilder setSize:30];
        [markerStyleBuilder setColor:[[NTColor alloc] initWithColor:0xFF00FF00]];
        NTMarkerStyle* sharedMarkerStyle = [markerStyleBuilder buildStyle];
        
        // Define position and add the marker to the Datasource (which is already in a Layer and MapView)
        NTMapPos* pos = [proj fromWgs84:[[NTMapPos alloc] initWithX:24.646469 y:59.426939]];
        NTMarker* marker = [[NTMarker alloc] initWithPos:pos style:sharedMarkerStyle];
        
        [vectorDataSource add:marker];
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









