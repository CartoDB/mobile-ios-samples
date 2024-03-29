
#import "MapBaseController.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface GPSLocationController : MapBaseController <CLLocationManagerDelegate>

@property CLLocationManager *manager;

@property NTMarker *positionMarker;
@property NTBalloonPopup *markerLabel;

@property NTLocalVectorDataSource *source;

@end

@implementation GPSLocationController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.contentView addBaseLayer: NT_CARTO_BASEMAP_STYLE_VOYAGER];
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.pausesLocationUpdatesAutomatically = YES;
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    float OSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (OSVersion >= 8.0f) {
        [self.manager requestAlwaysAuthorization];
    } else {
        [self.manager setAllowsBackgroundLocationUpdates:YES];
    }
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.manager startUpdatingLocation];
        
        NTProjection *projection = [[self.contentView.mapView getOptions] getBaseProjection];
        self.source = [[NTLocalVectorDataSource alloc] initWithProjection:projection];
        NTVectorLayer *layer = [[NTVectorLayer alloc] initWithDataSource:self.source];
        
        [[self.contentView.mapView getLayers] add:layer];
    }
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (locations.count == 0) {
        // Do not continue when there are no locations
        return;
    }
    
    CLLocation *location = [locations objectAtIndex:0];
    
    double latitude = location.coordinate.latitude;
    double longitude = location.coordinate.longitude;
    
    double course = location.course;
    
    NSString *title = @"Your current location is";
    
    NSString *description = [NSString stringWithFormat:@"%.04f, %.04f (course: %.0f)", latitude, longitude, course];
    
    NTProjection *projection = [[self.contentView.mapView getOptions] getBaseProjection];
    NTMapPos *position = [[NTMapPos alloc] initWithX:longitude y:latitude];
    position = [projection fromWgs84:position];
    
    if (self.positionMarker == nil) {
        
        NTMarkerStyleBuilder *builder = [[NTMarkerStyleBuilder alloc]init];
        [builder setAnchorPointX:0 anchorPointY:0];
        self.positionMarker = [[NTMarker alloc] initWithPos:position style:[builder buildStyle]];
        
        [self.source add:self.positionMarker];
        
        NTBalloonPopupStyleBuilder *balloonBuilder = [[NTBalloonPopupStyleBuilder alloc] init];
        self.markerLabel = [[NTBalloonPopup alloc] initWithBaseBillboard:self.positionMarker style:[balloonBuilder buildStyle] title:title desc:description];
        [self.source add:self.markerLabel];
        [self.contentView.mapView setZoom:19 durationSeconds:0];
    }
    
    self.markerLabel.description = description;
    [self.positionMarker setGeometry:[[NTPointGeometry alloc]initWithPos:position]];
    
    // following depends on marker graphics.
    // 180-course is ok if it is "arrow down"
    [self.positionMarker setRotation: 180 - course - self.contentView.mapView.getRotation];
    
    [self.contentView.mapView setFocusPos:position durationSeconds:0];
    
}

@end








