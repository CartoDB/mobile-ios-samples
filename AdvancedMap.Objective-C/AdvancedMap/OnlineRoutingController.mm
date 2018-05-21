
#import "BaseRoutingController.h"
#import "Sources.h"

@interface OnlineRoutingController : BaseRoutingController

@end

@implementation OnlineRoutingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create also online routing service if no offline package is yet downloaded
    self.service = [[NTCartoOnlineRoutingService alloc] initWithSource:@"nutiteq.osm.car"];
    
    [self hidePackageDownloadButton];
}

- (void)hidePackageDownloadButton {
    // For the sake of brevity and convenience,
    // both Online and Offline Reverse Geocoding controllers inherit from PackageDownloadBaseView.
    // Since this is our online sample, simply hide download the button,
    // PackageManager isn't initialized either, as it's not used
    [[self.contentView.buttons objectAtIndex:0] setHidden:YES];
}


@end
