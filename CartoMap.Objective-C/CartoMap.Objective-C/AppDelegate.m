#import "AppDelegate.h"
#import "LauncherListController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NTMapView registerLicense:@"XTUMwQ0ZIcXhuZ3RSdWdYNllQM25tRng2Q0tacGJGY2dBaFVBZ2N3K2dFTEFXRWx3OVdzbVF4aC90OVQxMEJJPQoKcHJvZHVjdHM9c2RrLWlvcy0zLioKYnVuZGxlSWRlbnRpZmllcj1jb20uY2FydG8uKgp3YXRlcm1hcms9Y3VzdG9tCnZhbGlkVW50aWw9MjAxNi0xMi0wMQp1c2VyS2V5PTM2M2YxNzdjZjM2NTAzMGYxZWU4YjkzY2JmNTY3OGRhCg"];
    
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
