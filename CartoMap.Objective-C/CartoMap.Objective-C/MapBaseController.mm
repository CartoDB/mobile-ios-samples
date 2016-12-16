
#import "MapBaseController.h"

@implementation MapBaseController

- (void)loadView
{
    self.mapView = [[NTMapView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.mapView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // GLKViewController-specific parameters for smoother animations
    [self setResumeOnDidBecomeActive:NO];
    [self setPreferredFramesPerSecond:60];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // GLKViewController-specific, do on-demand rendering instead of constant redrawing.
    // This is VERY IMPORTANT as it stops battery drain when nothing changes on the screen!
    [self setPaused:YES];
}

- (void)addGrayBaseLayer
{
    NTCartoOnlineVectorTileLayer *layer = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_GRAY];
    [[self.mapView getLayers] add:layer];
}

- (void)addDarkBaseLayer
{
    NTCartoOnlineVectorTileLayer *layer = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_DARK];
    [[self.mapView getLayers] add:layer];
}

-(void) alert:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view makeToast:message];
    });
}

@end
