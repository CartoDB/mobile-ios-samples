
#import <CartoMobileSDK/CartoMobileSDK.h>
#import "UIView+Toast.h"
#import "AlertMenu.h"
#import "MapBaseView.h"
/*
 * Base controller for map samples. Includes simple lifecycle management.
 */
@interface MapBaseController : UIViewController

@property (nonatomic,strong) MapBaseView* contentView;

-(void) alert:(NSString *)message;

-(NTProjection *)getProjection;

@property AlertMenu *alert;

@end
