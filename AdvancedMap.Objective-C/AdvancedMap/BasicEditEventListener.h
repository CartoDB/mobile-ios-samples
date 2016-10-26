
#import "CartoMobileSDK/CartoMobileSDK.h"

@interface BasicEditEventListener : NTVectorEditEventListener

@property NTPointStyle* styleNormal;
@property NTPointStyle* styleVirtual;
@property NTPointStyle* styleSelected;

@property NTLocalVectorDataSource* source;

@end
