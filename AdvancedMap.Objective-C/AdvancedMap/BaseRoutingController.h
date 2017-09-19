
#import "PackageDownloadBaseController.h"
#import "RouteClickListener.h"
#import "BaseRoutingView.h"

@interface BaseRoutingController : PackageDownloadBaseController

@property NTRoutingService* service;

@property RouteClickListener* mapListener;

- (void)setStart:(NTMapPos*)mapPos;
- (void)setStop:(NTMapPos*)mapPos;

@end
