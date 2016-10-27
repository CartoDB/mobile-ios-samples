
#import "MapBaseController.h"

/*
 * Base controller for vector map samples. Adds menu with multiple style choices.
 */
@interface VectorMapSampleBaseController : MapBaseController

- (NSDictionary*)languages;
- (NSDictionary*)styles;
- (void)updateBaseLayer;
- (NTTileDataSource*)createTileDataSource;

@property NSString* vectorStyleName;
@property NSString* vectorStyleLanguage;

@property NTVectorTileLayer* baseLayer;
@property NTTileDataSource* vectorTileDataSource;
@property NTMBVectorTileDecoder* vectorTileDecoder;

// Layer for Vector event listener
@property NTVectorLayer* vectorLayer;

@end
