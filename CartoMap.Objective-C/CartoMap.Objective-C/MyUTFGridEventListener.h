
#import <CartoMobileSDK/CartoMobileSDK.h>

@interface MyUTFGridEventListener : NTUTFGridEventListener

@property NTVectorLayer* vectorLayer;
@property NTVariant* infoWindowTemplate;
@property NTMapView* mapView;

@end
