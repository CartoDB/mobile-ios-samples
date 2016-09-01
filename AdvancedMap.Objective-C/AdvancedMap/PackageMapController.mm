#import "PackageMapController.h"

@implementation PackageMapController

@synthesize packageManager = _packageManager;

- (NTTileDataSource*)createTileDataSource
{
	return [[NTPackageManagerTileDataSource alloc] initWithPackageManager:_packageManager];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self.mapView setZoom:2.0f durationSeconds:0.2f];
	[self.mapView setTilt:90.0f durationSeconds:0.2f];
}

@end
