
#import "BaseVisController.h"

@interface StoresVisController : BaseVisController

@end

@implementation StoresVisController


-(void) viewDidLoad
{
    [self updateVis:@"https://maps-for-all.cartodb.com/api/v2/viz/78b33d4a-3dd6-11e6-8632-0ea31932ec1d/viz.json"];
}

@end
