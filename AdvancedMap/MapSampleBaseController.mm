#import "MapSampleBaseController.h"

@implementation MapSampleBaseController

- (void)loadView
{
    [NTLog setShowDebug:YES];
    [NTLog setShowInfo:YES];
    
    // The initial step: register your license. This must be done before using MapView!
    // The license string used here is intended only for Carto demos and WILL NOT WORK with other apps!
    [NTMapView registerLicense:@"XTUN3Q0ZHTWM3K2JKeWdDaGVBUnBTUm9aTlNuY3EwQ2dBaFJxWFZ6anhGOE9RdEpqTTRibVFJZXB3QncwK1E9PQoKcHJvZHVjdHM9c2RrLWlvcy00LioKYnVuZGxlSWRlbnRpZmllcj1jb20uY2FydG8uQWR2YW5jZWRNYXAKd2F0ZXJtYXJrPWRldmVsb3BtZW50CnZhbGlkVW50aWw9MjAxNi0wOC0yMApvbmxpbmVMaWNlbnNlPTEK"];

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
