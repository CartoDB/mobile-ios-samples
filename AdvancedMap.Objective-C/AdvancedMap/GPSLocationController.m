
#import "MapSampleBaseController.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface GPSLocationController : MapSampleBaseController <CLLocationManagerDelegate>

@property CLLocationManager *manager;

@property NTMarker *positionMarker;
@property NTBalloonPopup *markerLabel;

@property NTLocalVectorDataSource *source;

@end

@implementation GPSLocationController

-(void) viewDidLoad
{
    self.manager = [[CLLocationManager alloc] init];
    self.manager.pausesLocationUpdatesAutomatically = YES;
    self.manager.delegate = self;
    self.manager.desiredAccuracy =kCLLocationAccuracyKilometer;
    
    float OSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (OSVersion >= 8.0f) {
        [self.manager requestAlwaysAuthorization];
    } else {
        [self.manager setAllowsBackgroundLocationUpdates:YES];
    }
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.manager startUpdatingLocation];
        
        self.source = [[NTLocalVectorDataSource alloc] initWithProjection:[[self.mapView getOptions] getBaseProjection]];
        NTVectorLayer *layer = [[NTVectorLayer alloc] initWithDataSource:self.source];
        
        [[self.mapView getLayers] add:layer];
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
    
    NSString *title = @"Your current location is";
    
    NSString *description = [NSString stringWithFormat:@"%.04f", latitude];
    
    description = [description stringByAppendingString:@", "];
    description = [description stringByAppendingFormat:@"%.04f", longitude];
    
    NTProjection *projection = [[self.mapView getOptions] getBaseProjection];
    NTMapPos *position = [[NTMapPos alloc] initWithX:longitude y:latitude];
    position = [projection fromWgs84:position];
    
    if (self.positionMarker == nil) {
        
        NTMarkerStyleBuilder *builder = [[NTMarkerStyleBuilder alloc]init];
        self.positionMarker = [[NTMarker alloc] initWithPos:position style:[builder buildStyle]];
        [self.source add:self.positionMarker];
        
        NTBalloonPopupStyleBuilder *balloonBuilder = [[NTBalloonPopupStyleBuilder alloc] init];
        self.markerLabel = [[NTBalloonPopup alloc] initWithBaseBillboard:self.positionMarker style:[balloonBuilder buildStyle] title:title desc:description];
        [self.source add:self.markerLabel];
    }
    
    self.markerLabel.description = description;
    [self.positionMarker setGeometry:[[NTPointGeometry alloc]initWithPos:position]];
    
    [self.mapView setFocusPos:position durationSeconds:1];
    [self.mapView setZoom:19 durationSeconds:0];
}

@end








