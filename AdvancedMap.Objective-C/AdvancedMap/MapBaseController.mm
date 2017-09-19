
#import "MapBaseController.h"

@implementation MapBaseController

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.contentView = [[MapBaseView alloc] init];
    self.view = self.contentView;
    
    NTCartoOnlineVectorTileLayer* layer = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_VOYAGER];
    [[self.contentView.mapView getLayers] add:layer];
}

-(NTProjection *) getProjection
{
    return [[self.contentView.mapView getOptions] getBaseProjection];
}

@end
