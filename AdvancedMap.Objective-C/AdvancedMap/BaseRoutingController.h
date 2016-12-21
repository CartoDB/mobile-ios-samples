
#import "MapBaseController.h"

@interface  RouteClickListener : NTMapEventListener

@property (strong, nonatomic) NTMapView* mapView;
@property (strong, nonatomic) UIViewController* routingController;

@property (strong, nonatomic) NTMapPos* startPos;
@property (strong, nonatomic) NTMapPos* stopPos;
@property (strong, nonatomic) NTLocalVectorDataSource* routeDataSource;
@property (strong, nonatomic) NTBalloonPopup* oldClickLabel;

@end;

@interface BaseRoutingController : MapBaseController

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

@property BOOL isPackageDownloaded;

@end
