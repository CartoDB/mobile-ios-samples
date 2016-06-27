#import "VectorMapSampleBaseController.h"
#import "MyMapEventListener.h"
#import "MyVectorElementEventListener.h"

@interface Overlays2DSampleController : VectorMapSampleBaseController

@end;

/*
 * A sample displaying how to set custom MapListener
 * to detect clicks on map and on map vector elements.
 * Actual vector elements are added in Overlays2DActivity, as this class extends it.
 */
@interface MapListenerSampleController : Overlays2DSampleController

@end

@implementation MapListenerSampleController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    NTProjection* proj = [[self.mapView getOptions] getBaseProjection];
    NTLocalVectorDataSource* vectorDataSource1 = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
    // Initialize a vector layer with the previous data source
    NTVectorLayer* vectorLayer1 = [[NTVectorLayer alloc] initWithDataSource:vectorDataSource1];
    // Add the previous vector layer to the map
    [[self.mapView getLayers] add:vectorLayer1];

    // Create a map event listener
    MyMapEventListener* mapListener = [[MyMapEventListener alloc] init];
    [mapListener setMapView:self.mapView vectorDataSource:vectorDataSource1];
    [self.mapView setMapEventListener:mapListener];
    
    // Create vector element event listener
    MyVectorElementEventListener* vectorElementListener = [[MyVectorElementEventListener alloc] init];
    [vectorElementListener setMapView:self.mapView vectorDataSource:vectorDataSource1];
    for (int i = 0; i < [[self.mapView getLayers] count]; i++) {
        NTLayer* layer = [[self.mapView getLayers] get:i];
        if ([layer isKindOfClass:[NTVectorLayer class]]) {
            NTVectorLayer* vectorLayer = (NTVectorLayer*) layer;
            [vectorLayer setVectorElementEventListener:vectorElementListener];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	// Check if the view is closing
	if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        for (int i = 0; i < [[self.mapView getLayers] count]; i++) {
            NTLayer* layer = [[self.mapView getLayers] get:i];
            if ([layer isKindOfClass:[NTVectorLayer class]]) {
                NTVectorLayer* vectorLayer = (NTVectorLayer*) layer;
                [vectorLayer setVectorElementEventListener:nil];
            }
        }

        [self.mapView setMapEventListener:nil];
	}
	
	[super viewWillDisappear:animated];
}

@end
