
#import "MapBaseController.h"

@implementation MapBaseController

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.contentView = [[MapBaseView alloc] init];
    self.view = self.contentView;
}

-(NTProjection *) getProjection
{
    return [[self.contentView.mapView getOptions] getBaseProjection];
}

@end
