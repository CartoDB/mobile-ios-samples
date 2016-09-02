#import "AppDelegate.h"
#import "LauncherListController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NTMapView registerLicense:@"XTUN3Q0ZDZG5yUkZyTTRldVIvYWJwUWVVNjVQajk0cHFBaFFLUlkvMjlWazZETWIwSjlhRjBvR1JoMmNVc2c9PQoKcHJvZHVjdHM9c2RrLWlvcy00LioKYnVuZGxlSWRlbnRpZmllcj1jYXJ0by5DYXJ0b01hcC1PYmplY3RpdmUtQwp3YXRlcm1hcms9Y2FydG9kYgp2YWxpZFVudGlsPTIwMTYtMTAtMDIKb25saW5lTGljZW5zZT0xCg=="];
    
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
