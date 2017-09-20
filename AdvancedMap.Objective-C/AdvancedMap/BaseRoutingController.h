
#import "PackageDownloadBaseController.h"
#import "RouteClickListener.h"

@interface BaseRoutingController : PackageDownloadBaseController

@property NTRoutingService* service;

@property RouteClickListener* mapListener;

@property NTLocalVectorDataSource* routeDataSource;
@property NTLocalVectorDataSource* routeStartStopDataSource;

@property NTMarker* startMarker;
@property NTMarker* stopMarker;

@property NTMarkerStyle* instructionUp;
@property NTMarkerStyle* instructionLeft;
@property NTMarkerStyle* instructionRight;

- (void)setStart:(NTMapPos*)mapPos;
- (void)setStop:(NTMapPos*)mapPos;

@end
