
#import "OfflineRoutingBaseController.h"

@implementation OfflineRoutingBaseController

- (void)viewDidLoad
{
    // Create folder for package manager. Package manager needs persistent writable folder.
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask,YES);
    NSString* appSupportDir = [paths objectAtIndex: 0];
    NSString* packagesDir = [appSupportDir stringByAppendingString:@"/packages"];
    NSError *error;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:packagesDir withIntermediateDirectories:YES attributes:nil error:&error];
    
    self.packageManager = [[NTCartoPackageManager alloc] initWithSource:@"routing:nutiteq.osm.car" dataFolder:packagesDir];

    // Create offline routing service connected to package manager
    self.service = [[NTPackageManagerRoutingService alloc] initWithPackageManager:self.packageManager];
    
    // Call base class where most other setup is done
    [super viewDidLoad];
    
    self._packageManagerListener = [[RoutePackageManagerListener alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Register this controller with listener to receive notifications about events
    [self._packageManagerListener setRoutingController:self];
    [self._packageManagerListener setPackageManager:self.packageManager];
    
    [self.packageManager setPackageManagerListener:self._packageManagerListener];
    
    [self.packageManager start];
    [self.packageManager startPackageListDownload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.packageManager stop:YES];
    
    self._packageManagerListener = nil;
    [self.packageManager setPackageManagerListener:self._packageManagerListener];
}

@end














