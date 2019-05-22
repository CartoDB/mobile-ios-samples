#import "LauncherListController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define IsHeader(sample) [[sample objectForKey:@"controller"] rangeOfString:@"Header"].location != NSNotFound

@interface LauncherListController ()
@end

@interface MapListCell : UITableViewCell

@property UIView *topBorder;
@property UILabel *title;
@property UILabel *details;

@property BOOL isHeader;

-(void) update:(NSDictionary *)sample;

@end

@implementation LauncherListController

-(NSArray *) samples
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    Sample *sample = [[Sample alloc] init];
    sample.title = @"BASEMAP STYLES";
    sample.subtitle = @"Various samples of different CARTO Base Maps";
    sample.imageUrl = @"background_basemaps.png";
    sample.controller = @"BaseMapsController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"CUSTOM RASTER SOURCE";
    sample.subtitle = @"Creating and using custom raster tile data source";
    sample.imageUrl = @"background_custom_raster_source.png";
    sample.controller = @"CustomRasterDataSourceController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"GROUND OVERLAY";
    sample.subtitle = @"Adding ground-level raster overlay with indoor plan";
    sample.imageUrl = @"background_ground_overlay.png";
    sample.controller = @"GroundOverlayController";

    sample = [[Sample alloc] init];
    sample.title = @"ONLINE ROUTING";
    sample.subtitle = @"Online routing with OpenStreetMap data packages";
    sample.imageUrl = @"background_routing_online.png";
    sample.controller = @"OnlineRoutingController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"OFFLINE ROUTING";
    sample.subtitle = @"Routing where you first need to download a package";
    sample.imageUrl = @"background_routing_offline.png";
    sample.controller = @"OfflineRoutingController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"INDOOR ROUTING";
    sample.subtitle = @"Indoor offline routing";
    sample.imageUrl = @"background_routing_indoor.png";
    sample.controller = @"IndoorRoutingController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"WMS MAP";
    sample.subtitle = @"WMS raster map on top of vector base map";
    sample.imageUrl = @"background_wms.png";
    sample.controller = @"WMSMapController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"CLUSTERED MARKERS";
    sample.subtitle = @"Read points from .geojson and show as dynamic clusters";
    sample.imageUrl = @"background_clusters.png";
    sample.controller = @"ClusteredMarkersController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"OVERLAYS";
    sample.subtitle = @"2D & 3D objects: lines, points, polygons, texts, pop-ups, 3D models";
    sample.imageUrl = @"background_overlays.png";
    sample.controller = @"OverlaysController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"OBJECT EDITING";
    sample.subtitle = @"Editable vector layer to modify lines, points and polygons";
    sample.imageUrl = @"background_object_editing.png";
    sample.controller = @"VectorObjectEditingController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"ONLINE REVERSE GEOCODING";
    sample.subtitle = @"Online reverse geocoding with Mapbox geocoder";
    sample.imageUrl = @"background_online_reverse_geocoding.png";
    sample.controller = @"OnlineReverseGeocodingController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"ONLINE GEOCODING";
    sample.subtitle = @"Online geocoding with Mapbox geocoder";
    sample.imageUrl = @"background_online_geocoding.png";
    sample.controller = @"OnlineGeocodingController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"OFFLINE REVERSE GEOCODING";
    sample.subtitle = @"Download and package and click the map to find an address";
    sample.imageUrl = @"background_offline_reverse_geocoding.png";
    sample.controller = @"OfflineReverseGeocodingController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"OFFLINE GEOCODING";
    sample.subtitle = @"Download and package and search for an address";
    sample.imageUrl = @"background_offline_geocoding.png";
    sample.controller = @"OfflineGeocodingController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"BUNDLED MAP";
    sample.subtitle = @"Use bundled MBTiles vector file to show offline map";
    sample.imageUrl = @"background_bundled_map.png";
    sample.controller = @"BundledMapController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"OFFLINE MAP";
    sample.subtitle = @"Download map packages for offline use";
    sample.imageUrl = @"background_advanced_package_manager.png";
    sample.controller = @"OfflineMapController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"SCREENCAPTURE";
    sample.subtitle = @"Saves rendered MapView as a bitmap and shares it";
    sample.imageUrl = @"background_screen_capture.png";
    sample.controller = @"CaptureController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"CUSTOM POPUP";
    sample.subtitle = @"Add acustomized Popups to your MapView";
    sample.imageUrl = @"background_custom_popup.png";
    sample.controller = @"CustomPopupController";
    [array addObject: sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"GPS LOCATION";
    sample.subtitle = @"Shows device GNSS location on map";
    sample.imageUrl = @"background_gps_location";
    sample.controller = @"GPSLocationController";
    [array addObject: sample];
    
    return array;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Advanced Map";
    
    self.contentView = [[MainView alloc] init];
    self.view = self.contentView;
    
    [self.contentView addRowsWithRows:self.samples];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.contentView.galleryDelegate = self;
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void) galleryItemClickWithItem:(GalleryRow *)item {
    
    // Launch selected sample, use basic reflection to convert class name to class instance
    UIViewController* controller = [[NSClassFromString(item.sample.controller) alloc] init];
    [controller setTitle: item.sample.title];
    [[self navigationController] pushViewController:controller animated:true];
}

@end












