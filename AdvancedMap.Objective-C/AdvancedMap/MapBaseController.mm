
#import "MapBaseController.h"

@implementation MapBaseController

- (void)loadView
{
    self.mapView = [[NTMapView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.mapView;
    
    NTCartoOnlineVectorTileLayer* layer = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_DEFAULT];
    
    [[self.mapView getLayers] add:layer];
    
    self.alert = [[AlertMenu alloc]init];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

    // GLKViewController-specific parameters for smoother animations
    [self setResumeOnDidBecomeActive:NO];
    [self setPreferredFramesPerSecond:60];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // GLKViewController-specific, do on-demand rendering instead of constant redrawing.
    // This is VERY IMPORTANT as it stops battery drain when nothing changes on the screen!
    [self setPaused:YES];
}

-(void) alert:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.alert show:message];
    });
}

@end
