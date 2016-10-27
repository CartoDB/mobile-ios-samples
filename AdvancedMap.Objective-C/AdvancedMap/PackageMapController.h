#import "MapBaseController.h"

/*
 * A sample that uses PackageManager service for offline base map.
 * This controller is used as launched from PackageManagerController.
 */
@interface PackageMapController : MapBaseController

@property (nonatomic,strong) NTPackageManager* packageManager;

@end
