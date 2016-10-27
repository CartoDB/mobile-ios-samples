#import <GLKit/GLKit.h>
#import <CartoMobileSDK/CartoMobileSDK.h>

/*
 * Base controller for map samples. Includes simple lifecycle management.
 */
@interface MapBaseController : GLKViewController

@property (nonatomic,strong) NTMapView* mapView;

@end
