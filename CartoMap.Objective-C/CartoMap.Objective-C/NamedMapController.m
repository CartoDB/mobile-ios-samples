
#import "MapBaseController.h"
#import "VectorTileListener.h"
#import "MapEventListener.h"

@interface NamedMapController : MapBaseController

@property NTCartoMapsService *service;
@property NTVectorTileLayer *layer;
@property VectorTileListener *objectListener;
@property MapEventListener *mapListener;

@end


@implementation NamedMapController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.service = [[NTCartoMapsService alloc] init];
    [self.service setUsername:@"nutiteq"];
    // Use raster layers, not vector layers
    [self.service setDefaultVectorLayerMode:YES];

    // Coordinates are available in the viz.json we download
    NTProjection* projection = [[self.mapView getOptions] getBaseProjection];
    NTMapPos* position = [projection fromLat:37.32549682016584 lng:-121.94595158100128];
    [self.mapView setFocusPos:position durationSeconds:0];
    [self.mapView setZoom:17 durationSeconds:0];
    
    self.objectListener = [[VectorTileListener alloc] init];
    NTLocalVectorDataSource *source = [[NTLocalVectorDataSource alloc] initWithProjection:projection];
    self.objectListener.vectorLayer = [[NTVectorLayer alloc] initWithDataSource:source];
    
    self.mapListener = [[MapEventListener alloc] init];
    self.mapListener.source = source;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NTLayerVector *layers = [self.service buildNamedMap:@"tpl_69f3eebe_33b6_11e6_8634_0e5db1731f59" templateParams: [[NTStringVariantMap alloc] init]];
    
    [[self.mapView getLayers] addAll:layers];
    [[self.mapView getLayers] add:self.objectListener.vectorLayer];
    
    for (int i = 0; i < [layers size]; i++) {
        
        NTLayer *layer = [layers get:i];
        
        if ([layer isKindOfClass:NTVectorTileLayer.class]) {
            self.layer = (NTVectorTileLayer *)layer;
            [self.layer setVectorTileEventListener:self.objectListener];
        }
    }
    
    [self.mapView setMapEventListener:self.mapListener];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.layer != nil) {
        [self.layer setVectorTileEventListener:nil];
    }
    
    [[self.mapView getLayers] clear];
    
    [self.mapView setMapEventListener:nil];
}

@end








