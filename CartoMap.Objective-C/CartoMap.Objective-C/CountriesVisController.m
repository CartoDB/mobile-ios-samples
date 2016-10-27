
#import "BaseVisController.h"

@interface CountriesVisController : BaseVisController

@end

@implementation CountriesVisController


-(void) viewDidLoad
{
    // Countries VisJson
    // Displays countries in different colors
    
    [self updateVis:@"http://documentation.cartodb.com/api/v2/viz/2b13c956-e7c1-11e2-806b-5404a6a683d5/viz.json"];
}

@end