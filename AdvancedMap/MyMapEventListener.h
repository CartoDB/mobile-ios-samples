#import <CartoMobileSDK/CartoMobileSDK.h>

/*
 * A custom map event listener that displays information about map events and creates pop-ups.
 */
@interface  MyMapEventListener : NTMapEventListener

-(void)setMapView:(NTMapView*)mapView vectorDataSource:(NTLocalVectorDataSource*)vectorDataSource;
-(void)onMapMoved;
-(void)onMapClicked:(NTMapClickInfo*)mapClickInfo;

@end