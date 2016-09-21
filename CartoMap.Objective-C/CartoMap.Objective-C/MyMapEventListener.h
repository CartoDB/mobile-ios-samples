
#import <CartoMobileSDK/CartoMobileSDK.h>

@interface MyMapEventListener : NTMapEventListener

@property NTMapView* mapView;
@property NTLocalVectorDataSource* source;

@end