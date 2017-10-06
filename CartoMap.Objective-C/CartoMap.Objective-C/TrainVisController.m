
#import "BaseVisController.h"

@interface TrainVisController : BaseVisController

@end

@implementation TrainVisController


-(void) viewDidLoad
{
    [self updateVis:@"https://mamataakella.cartodb.com/api/v2/viz/30730478-bbb5-11e5-b75c-0e5db1731f59/viz.json"];
}

@end
