#import "AppDelegate.h"
#import "LauncherListController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
    LauncherListController* controller = [[LauncherListController alloc] init];
	
    self.navigationController = [[UINavigationController alloc] initWithRootViewController: controller];
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    [self.window setRootViewController: self.navigationController];
	[self.window makeKeyAndVisible];
	
    return YES;
}

@end
