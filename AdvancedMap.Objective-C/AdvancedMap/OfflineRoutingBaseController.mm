
#import "OfflineRoutingBaseController.h"

@implementation OfflineRoutingBaseController

- (void)viewDidLoad
{
    NSString *directory = [self getPackageDirectory];
 
    NSError *error;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
    
    self.packageManager = [[NTCartoPackageManager alloc] initWithSource:[self getSource] dataFolder:directory];
    
    // Create offline routing service connected to package manager
    self.service = [self getService];
    
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

- (NSString *) getSource
{
    return @"routing:nutiteq.osm.car";
}

- (NSString *) getPackageDirectory
{
    return [[self getAppSupportDirectory ] stringByAppendingString:@"/packages"];
}

- (NSString *) getAppSupportDirectory
{
    // Create folder for package manager. Package manager needs persistent writable folder.
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask,YES);
    return [paths objectAtIndex: 0];
}

- (NTRoutingService *)getService
{
    return [[NTPackageManagerRoutingService alloc] initWithPackageManager:self.packageManager];
}

@end














