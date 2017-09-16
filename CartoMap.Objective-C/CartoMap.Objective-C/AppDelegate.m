#import "AppDelegate.h"
#import "LauncherListController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NTMapView registerLicense:@"XTUN3Q0ZER0R5UmN4cGduS0N1K3NaSDdLeVhySCs4cDZBaFJoSWVhdjBjTFdDTFgxejQ2KzNMT2xkc0dyVlE9PQoKYXBwVG9rZW49YzdmMGVhYjktMzgzOS00YzQ3LWJjMjctYjlhNjk1MWFiYWU2CmJ1bmRsZUlkZW50aWZpZXI9Y29tLmNhcnRvLmNhcnRvLm1hcApvbmxpbmVMaWNlbnNlPTEKcHJvZHVjdHM9c2RrLWlvcy00LioKd2F0ZXJtYXJrPWN1c3RvbQo="];
    
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
