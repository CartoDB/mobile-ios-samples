#import "AppDelegate.h"
#import "LauncherListController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NTMapView registerLicense:@"XTUN3Q0ZDS1ZDazMrTlZUd3BnRjB2ZnFhRFVXcDV3KzNBaFE2Q0grUmpUSXlhUkprUHdYSXZ6S3dkZFBBdlE9PQoKYXBwVG9rZW49OWQ0MmQ2MWItNDhjMi00OGJmLTg4ZDktMmY5OTA0OTYwNDdlCmJ1bmRsZUlkZW50aWZpZXI9Y29tLmNhcnRvLkNhcnRvTWFwCm9ubGluZUxpY2Vuc2U9MQpwcm9kdWN0cz1zZGstaW9zLTQuKgp3YXRlcm1hcms9Y3VzdG9tCg=="];
    
    [NTLog setShowDebug:YES];
    [NTLog setShowInfo:YES];
    
    LauncherListController* controller = [[LauncherListController alloc] init];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController: controller];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window setRootViewController: self.navigationController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
