
#import "BaseRoutingController.h"
#import "Sources.h"

@interface OnlineRoutingController : BaseRoutingController

@end

@implementation OnlineRoutingController

- (void)viewDidLoad
{
    // Create also online routing service if no offline package is yet downloaded
    NSString *source = [ONLINE_ROUTING_SOURCE stringByAppendingString: TRANSPORT_MODE_CAR];
    self.service = [[NTCartoOnlineRoutingService alloc] initWithSource:source];
    
    // There are no packages to download, simply set the flag to true
    self.mapListener.isPackageDownloaded = YES;
    
    // Call base class where most other setup is done
    [super viewDidLoad];
}


@end
