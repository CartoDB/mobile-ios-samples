
#import <GLKit/GLKit.h>
#import <CartoMobileSDK/CartoMobileSDK.h>
#import "MapBaseController.h"

@interface VectorMapBaseController : MapBaseController

- (NSDictionary*)languages;
- (NSDictionary*)styles;
- (void)updateBaseLayer;
- (NTTileDataSource*)createTileDataSource;

@property NSString* vectorStyleName;
@property NSString* vectorStyleLanguage;

@property NTVectorTileLayer* baseLayer;
@property NTTileDataSource* vectorTileDataSource;
@property NTMBVectorTileDecoder* vectorTileDecoder;

@end
