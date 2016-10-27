
#import "MapBaseController.h"

@implementation MapBaseController

- (void)loadView
{
    [NTLog setShowDebug:YES];
    [NTLog setShowInfo:YES];
    
    // The initial step: register your license. This must be done before using MapView!
    // The license string used here is intended only for Carto demos and WILL NOT WORK with other apps!
    [NTMapView registerLicense:@"XTUMwQ0ZDdVp4Qm1RV2QvTWxCQU1KU3hFL09iV2RwU2NBaFVBbzJhRUFORUxBVlY3cy9HSVY5aENqaWFxZDU4PQoKYXBwVG9rZW49ZmM2YzdhYzktMGUxYi00MTU4LWE2MjktYzBhYThiZGY5ZDgzCmJ1bmRsZUlkZW50aWZpZXI9Y29tLmNhcnRvLkFkdmFuY2VkTWFwCm9ubGluZUxpY2Vuc2U9MQpwcm9kdWN0cz1zZGstaW9zLTQuKgp3YXRlcm1hcms9Y3VzdG9tCg=="];

    self.mapView = [[NTMapView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.mapView;
    
    NTCartoOnlineVectorTileLayer* layer = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_DEFAULT];
    
    [[self.mapView getLayers] add:layer];
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

@end
