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
    [NTMapView registerLicense:@"XTUMwQ0ZDdVp4Qm1RV2QvTWxCQU1KU3hFL09iV2RwU2NBaFVBbzJhRUFORUxBVlY3cy9HSVY5aENqaWFxZDU4PQoKYXBwVG9rZW49ZmM2YzdhYzktMGUxYi00MTU4LWE2MjktYzBhYThiZGY5ZDgzCmJ1bmRsZUlkZW50aWZpZXI9Y29tLmNhcnRvLkFkdmFuY2VkTWFwCm9ubGluZUxpY2Vuc2U9MQpwcm9kdWN0cz1zZGstaW9zLTQuKgp3YXRlcm1hcms9Y3VzdG9tCg=="];

    return YES;
}

@end
