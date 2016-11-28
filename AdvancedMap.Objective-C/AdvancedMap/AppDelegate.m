#import "AppDelegate.h"
#import "LauncherListController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
    LauncherListController* controller = [[LauncherListController alloc] init];
	
    self.navigationController = [[UINavigationController alloc] initWithRootViewController: controller];
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    [self.window setRootViewController: self.navigationController];
	[self.window makeKeyAndVisible];

    [NTLog setShowDebug:YES];
    [NTLog setShowInfo:YES];
    
    // The initial step: register your license. This must be done before using MapView!
    // The license string used here is intended only for Carto demos and WILL NOT WORK with other apps!
    [NTMapView registerLicense:@"XTUN3Q0ZEenZKWnNJSmZTQ1pHeEZreTFpVnNsNmJkQ0pBaFE3QldULzNPZUt4czBMNHpRUk5VaTFQenVsMmc9PQoKYXBwVG9rZW49N2I4ZjkzODItNGYzMC00ZDBiLWIxY2YtMWUwZTVkZDUwZjgwCmJ1bmRsZUlkZW50aWZpZXI9Y2FydG8uQWR2YW5jZWRNYXAtT2JqZWN0aXZlLUMKb25saW5lTGljZW5zZT0xCnByb2R1Y3RzPXNkay1pb3MtNC4qCndhdGVybWFyaz1jdXN0b20K"];

    return YES;
}

@end
