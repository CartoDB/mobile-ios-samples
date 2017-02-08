#import <GLKit/GLKit.h>
#import <CartoMobileSDK/CartoMobileSDK.h>
#import "UIView+Toast.h"
#import "AlertMenu.h"

/*
 * Base controller for map samples. Includes simple lifecycle management.
 */
@interface MapBaseController : GLKViewController

@property (nonatomic,strong) NTMapView* mapView;

-(void) alert:(NSString *)message;

@property AlertMenu *alert;

@end
