
#import "BaseRoutingController.h"
#import "Sources.h"

@interface OnlineRoutingController : BaseRoutingController

@end

@implementation OnlineRoutingController

- (void)viewDidLoad
{
    // Create also online routing service if no offline package is yet downloaded
    self.service = [[NTValhallaOnlineRoutingService alloc]initWithApiKey:MAPZEN_API_KEY];
    
    // Valhalla has variou profiles,
    // cf: https://mapzen.com/documentation/mobility/turn-by-turn/api-reference/#costing-models
    [((NTValhallaOnlineRoutingService *)self.service) setProfile:@"auto"];
    
    // Call base class where most other setup is done
    [super viewDidLoad];
    
    // There are no packages to download, simply set the flag to true
    self.mapListener.isPackageDownloaded = YES;
}


@end
