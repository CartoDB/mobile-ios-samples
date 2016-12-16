
#import <GLKit/GLKit.h>
#import <CartoMobileSDK/CartoMobileSDK.h>
#import "UIView+Toast.h"

/*
 * Base controller for map samples. Includes simple lifecycle management.
 */
@interface MapBaseController : GLKViewController

@property (nonatomic,strong) NTMapView* mapView;

- (void)addGrayBaseLayer;
- (void)addDarkBaseLayer;

-(void) alert:(NSString *)message;

@end
