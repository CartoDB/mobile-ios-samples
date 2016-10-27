
#import "BaseVisController.h"

@interface FontsVisController : BaseVisController

@end

@implementation FontsVisController


-(void) viewDidLoad
{
    // Fonts VisJson
    // Displays text on the map
    
    [self updateVis:@"https://cartomobile-team.carto.com/u/nutiteq/api/v2/viz/13332848-27da-11e6-8801-0e5db1731f59/viz.json"];
}

@end