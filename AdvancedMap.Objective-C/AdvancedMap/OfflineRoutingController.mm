
#import "BaseRoutingController.h"

@interface RoutePackageManagerListener : NTPackageManagerListener

- (void)onPackageListUpdated;
- (void)onPackageListFailed;
- (void)onPackageUpdated:(NSString*)packageId version:(int)version;
- (void)onPackageCancelled:(NSString*)packageId version:(int)version;
- (void)onPackageFailed:(NSString*)packageId version:(int)version errorType:(enum NTPackageErrorType)errorType;
- (void)onPackageStatusChanged:(NSString*)packageId version:(int)version status:(NTPackageStatus*)status;

@property UIViewController* routingController;
@property NTPackageManager* packageManager;

@end

@interface OfflineRoutingController : BaseRoutingController

@property NTCartoPackageManager* packageManager;
@property RoutePackageManagerListener* _packageManagerListener;

@end

@implementation OfflineRoutingController

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
    
    NTProjection *proj = [[self.mapView getOptions]getBaseProjection];
    NTMapPos *andorra = [[NTMapPos alloc]initWithX:1.5218 y:42.5063];
    
    // Zoom to Andorra as this is the package we're downloading
    [self.mapView setFocusPos:[proj fromWgs84:andorra]  durationSeconds:0];
    [self.mapView setZoom:10 durationSeconds:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self alert:@"This example downloads a routing package (not a map package) of Andorra, Europe"];
    
    self._packageManagerListener = [[RoutePackageManagerListener alloc] init];
    
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

@implementation RoutePackageManagerListener

- (void)getPackage:(NSString *)package
{
    NTPackageStatus* status = [_packageManager getLocalPackageStatus: package version:-1];
    
    if (status == nil) {
        [_packageManager startPackageDownload: package];
    } else if ([status getCurrentAction] == NT_PACKAGE_ACTION_READY) {
        
        ((OfflineRoutingController*)self.routingController).isPackageDownloaded = YES;
        
        [(OfflineRoutingController*)self.routingController alert:[NSString stringWithFormat:@"Routing package %@ downloaded", package ]];
    }
}

- (void)onPackageListUpdated
{
    NSLog(@"onPackageListUpdated");
    // We have packages all country/regions
    // You can download several packages, and route is found through all of them
    
    [self getPackage:@"AD-routing"];
}

- (void)onPackageListFailed
{
    NSLog(@"onPackageListFailed");
}

- (void)onPackageUpdated:(NSString*)packageId version:(int)version
{
    ((OfflineRoutingController*)self.routingController).isPackageDownloaded = YES;
}

- (void)onPackageCancelled:(NSString*)packageId version:(int)version
{
}

- (void)onPackageFailed:(NSString*)packageId version:(int)version errorType:(enum NTPackageErrorType)errorType
{
    NSLog(@"onPackageFailed");
}

- (void)onPackageStatusChanged:(NSString*)packageId version:(int)version status:(NTPackageStatus*)status
{
    NSLog(@"onPackageStatusChanged progress: %f", [status getProgress]);
}

@end













