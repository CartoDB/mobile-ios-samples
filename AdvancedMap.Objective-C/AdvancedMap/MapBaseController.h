
#import <CartoMobileSDK/CartoMobileSDK.h>
#import "MapBaseView.h"
/*
 * Base controller for map samples. Includes simple lifecycle management.
 */
@interface MapBaseController : UIViewController

@property (nonatomic,strong) MapBaseView* contentView;

-(NTProjection *)getProjection;

@end
