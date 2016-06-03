#import "VectorMapSampleBaseController.h"

/*
 * A sample that uses PackageManager service for offline base map.
 * This controller is used as launched from PackageManagerController.
 */
@interface PackageMapController : VectorMapSampleBaseController

@property (nonatomic,strong) NTPackageManager* packageManager;

@end
