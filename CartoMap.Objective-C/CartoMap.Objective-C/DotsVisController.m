
#import "BaseVisController.h"

@interface DotsVisController : BaseVisController

@end

@implementation DotsVisController


-(void) viewDidLoad
{
    // Dots VisJson
    // Shows dots on the map
    
    [self updateVis:@"https://documentation.cartodb.com/api/v2/viz/236085de-ea08-11e2-958c-5404a6a683d5/viz.json"];
}

@end