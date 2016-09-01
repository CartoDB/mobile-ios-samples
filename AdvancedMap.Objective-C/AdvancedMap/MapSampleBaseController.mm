#import "MapSampleBaseController.h"

@implementation MapSampleBaseController

- (void)loadView
{
    [NTLog setShowDebug:YES];
    [NTLog setShowInfo:YES];
    
    // The initial step: register your license. This must be done before using MapView!
    // The license string used here is intended only for Carto demos and WILL NOT WORK with other apps!
    [NTMapView registerLicense:@"XTUMwQ0ZIcXhuZ3RSdWdYNllQM25tRng2Q0tacGJGY2dBaFVBZ2N3K2dFTEFXRWx3OVdzbVF4aC90OVQxMEJJPQoKcHJvZHVjdHM9c2RrLWlvcy0zLioKYnVuZGxlSWRlbnRpZmllcj1jb20uY2FydG8uKgp3YXRlcm1hcms9Y3VzdG9tCnZhbGlkVW50aWw9MjAxNi0xMi0wMQp1c2VyS2V5PTM2M2YxNzdjZjM2NTAzMGYxZWU4YjkzY2JmNTY3OGRhCg"];

    self.mapView = [[NTMapView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = self.mapView;
  
    [self.mapView.getOptions setPanningMode:NTPanningMode::NT_PANNING_MODE_STICKY_FINAL];
    
    [self.mapView.getOptions setWatermarkBitmap:nil];
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
