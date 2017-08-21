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
	
    [self setTitle:@"Packaged map"];
    
    // Clear default base layer, as we're using a different layer here
    [[self.mapView getLayers] clear];
    
    NTCartoOfflineVectorTileLayer *layer = [[NTCartoOfflineVectorTileLayer alloc]initWithPackageManager:_packageManager style:NT_CARTO_BASEMAP_STYLE_VOYAGER];
    [[self.mapView getLayers] add:layer];
}

@end
