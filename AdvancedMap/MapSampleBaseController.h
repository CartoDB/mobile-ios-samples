#import <GLKit/GLKit.h>
#import <CartoMobileSDK/CartoMobileSDK.h>

/*
 * Base controller for map samples. Includes simple lifecycle management.
 */
@interface MapSampleBaseController : GLKViewController

@property (nonatomic,strong) NTMapView* mapView;

@end
