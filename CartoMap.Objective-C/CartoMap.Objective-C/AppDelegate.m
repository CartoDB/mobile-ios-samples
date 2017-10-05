
#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NTMapView registerLicense:@"XTUN3Q0ZER0R5UmN4cGduS0N1K3NaSDdLeVhySCs4cDZBaFJoSWVhdjBjTFdDTFgxejQ2KzNMT2xkc0dyVlE9PQoKYXBwVG9rZW49YzdmMGVhYjktMzgzOS00YzQ3LWJjMjctYjlhNjk1MWFiYWU2CmJ1bmRsZUlkZW50aWZpZXI9Y29tLmNhcnRvLmNhcnRvLm1hcApvbmxpbmVMaWNlbnNlPTEKcHJvZHVjdHM9c2RrLWlvcy00LioKd2F0ZXJtYXJrPWN1c3RvbQo="];
    
    [NTLog setShowDebug:YES];
    [NTLog setShowInfo:YES];
    
    MainViewController* controller = [[MainViewController alloc] init];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController: controller];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window setRootViewController: self.navigationController];
    [self.window makeKeyAndVisible];
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                UIColor.whiteColor, NSForegroundColorAttributeName, nil];
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:UIColor.whiteColor];
    [bar setBarTintColor:[UIColor colorWithRed:242/255.0f green:68/255.0f blue:64/255.0f alpha:1.0]];
    [bar setTitleTextAttributes:attributes];
    
    return YES;
}

@end
