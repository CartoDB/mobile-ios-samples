
#import "MapBaseController.h"

@interface BoundingBox : NSObject

@property double minLat;
@property double minLon;
@property double maxLat;
@property double maxLon;

- (NSString *)toString;
- (NTMapPos *)getCenter;

@end

@interface BasicPackageManagerController : MapBaseController

@property UILabel *status;

@property NTCartoPackageManager *manager;

@property BoundingBox *bbox;

- (void)zoomTo:(NTMapPos *)position;
- (void)updatePackage:(NSString *)message;

@end

@interface PackageListener : NTPackageManagerListener

@property BasicPackageManagerController *controller;

@end

@implementation BasicPackageManagerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Clear default base layer
    [[self.mapView getLayers] clear];
    
    NSString *folder = [self createFolder:@"citypackages"];
    
    [self setStatusLabel];
    
    self.bbox = [[BoundingBox alloc]init];
    self.bbox.minLon = -0.8164;
    self.bbox.minLat = 51.2382;
    self.bbox.maxLon = 0.6406;
    self.bbox.maxLat = 51.7401;
    
    self.manager = [[NTCartoPackageManager alloc] initWithSource:@"nutiteq.osm" dataFolder:folder];
    [self.manager setPackageManagerListener:[[PackageListener alloc]init]];
    
    [self setbaseLayer];
    
    NSString *package = [self.bbox toString];
    
    if ([self.manager getLocalPackageStatus:package version:-1] == nil) {
        [self.manager startPackageRemove:package];
    } else {
        [self zoomTo:[self.bbox getCenter]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.manager start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.manager stop:true];
}

- (void)updatePackage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.status setText:message];
    });
}

- (NSString *)createFolder:(NSString *)folder
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask,YES);
    
    NSString* appSupportDir = [paths objectAtIndex: 0];
    NSString* packagesDir = [appSupportDir stringByAppendingString:folder];
    
    NSError *error;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:packagesDir withIntermediateDirectories:YES attributes:nil error:&error];
    
    return packagesDir;
}

- (void)zoomTo:(NTMapPos *)position
{
    // Translate position to WGS84
    position = [[[self.mapView getOptions]getBaseProjection] fromWgs84:position];
    
    [self.mapView setFocusPos:position durationSeconds:0];
    [self.mapView setZoom:12 durationSeconds:2];
}

- (void)setStatusLabel
{
    self.status = [[UILabel alloc]init];
    [self.status setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7]];
    [self.status setTextColor:[UIColor blackColor]];
    [self.status setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    
    [self.status setTextAlignment:NSTextAlignmentCenter];
    [self.status setLineBreakMode:NSLineBreakByWordWrapping];
    
    [[self.status layer] setCornerRadius:5];
    [self.status setClipsToBounds:true];
    
    [self.mapView addSubview:self.status];
    
    CGRect screen = [UIScreen mainScreen].bounds;
    
    float width = screen.size.width / 2;
    float height = width / 4;
    
    
    float x = screen.size.width / 2 - width / 2;
    float y = [[UIApplication sharedApplication] statusBarFrame].size.height + [[self.navigationController navigationBar] frame].size.height + 10;
    
    [self.status setFrame:CGRectMake(x, y, width, height)];
}

- (void)setbaseLayer
{
    NTCartoOfflineVectorTileLayer *layer = [[NTCartoOfflineVectorTileLayer alloc]initWithPackageManager:self.manager style:NT_CARTO_BASEMAP_STYLE_DEFAULT];
    [[self.mapView getLayers] add:layer];
}

@end

@implementation PackageListener

- (void)onPackageListUpdated
{
    // Basic sample does not download a package list
    // See advanced sample on this usage
}

- (void)onPackageListFailed
{
    // Basic sample does not download a package list
    // See advanced sample on this usage
}

- (void)onPackageUpdated:(NSString*)packageId version:(int)version
{
    NSString *message = @"Download complete";
    [self.controller updatePackage:message];
    [self.controller zoomTo:[self.controller.bbox getCenter]];
}

- (void)onPackageCancelled:(NSString*)packageId version:(int)version
{
    // Basic sample does not feature package cancellation
    // See advanced sample on this
}

- (void)onPackageFailed:(NSString*)packageId version:(int)version errorType:(enum NTPackageErrorType)errorType
{
    NSString *message = @"Download failed";
    [self.controller updatePackage:message];
}

- (void)onPackageStatusChanged:(NSString*)packageId version:(int)version status:(NTPackageStatus*)status
{
    
    NSString *percent = [[NSNumber numberWithFloat:[status getProgress]] stringValue];
    NSString *message = [[@"Progress: " stringByAppendingString:percent] stringByAppendingString:@"%"];
    
    [self.controller updatePackage:message];
}

@end

@implementation BoundingBox

- (NTMapPos *)getCenter
{
    double x = (self.maxLon + self.minLon) / 2;
    double y = (self.maxLat + self.minLat) / 2;
    
    return [[NTMapPos alloc]initWithX:x y:y];
}

- (NSString *)toString;
{
    NSString *minLat = [NSString stringWithFormat:@"%.04f", self.minLat];
    NSString *minLon = [NSString stringWithFormat:@"%.04f", self.minLon];
    NSString *maxLat = [NSString stringWithFormat:@"%.04f", self.maxLat];
    NSString *maxLon = [NSString stringWithFormat:@"%.04f", self.maxLon];
    
    return [[[[[[[[@"bbox("
                   stringByAppendingString:minLon] stringByAppendingString:@","]
                 stringByAppendingString:minLat] stringByAppendingString:@","]
               stringByAppendingString:maxLon]stringByAppendingString:@","]
             stringByAppendingString:maxLat] stringByAppendingString:@")"];
}

@end








