
#import "BaseRoutingController.h"

@interface OnlineRoutingController : BaseRoutingController

@end

@implementation OnlineRoutingController

- (void)viewDidLoad
{
    // Create also online routing service if no offline package is yet downloaded
    self.service = [[NTCartoOnlineRoutingService alloc] initWithSource:@"nutiteq.osm.car"];
    
    // There are no packages to download, simply set the flag to true
    self.isPackageDownloaded = YES;
    
    // Call base class where most other setup is done
    [super viewDidLoad];
}


@end
