#import "MapSampleBaseController.h"

@implementation MapSampleBaseController

- (void)loadView
{
    [NTLog setShowDebug:YES];
    [NTLog setShowInfo:YES];
    
    // The initial step: register your license. This must be done before using MapView!
    // The license string used here is intended only for Carto demos and WILL NOT WORK with other apps!
    [NTMapView registerLicense:@"XTUN3Q0ZBd2NtcmFxbUJtT1h4QnlIZ2F2ZXR0Mi9TY2JBaFJoZDNtTjUvSjJLay9aNUdSVjdnMnJwVXduQnc9PQoKcHJvZHVjdHM9c2RrLWlvcy0zLiosc2RrLWFuZHJvaWQtMy4qCnBhY2thZ2VOYW1lPWNvbS5udXRpdGVxLioKYnVuZGxlSWRlbnRpZmllcj1jb20ubnV0aXRlcS4qCndhdGVybWFyaz1ldmFsdWF0aW9uCnVzZXJLZXk9MTVjZDkxMzEwNzJkNmRmNjhiOGE1NGZlZGE1YjA0OTYK"];

    self.mapView = [[NTMapView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = self.mapView;
  
    [self.mapView.getOptions setPanningMode:NTPanningMode::NT_PANNING_MODE_STICKY_FINAL];
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
