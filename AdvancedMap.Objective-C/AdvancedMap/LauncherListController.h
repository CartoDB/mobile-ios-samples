#import <CartoMobileSDK/CartoMobileSDK.h>
#import "AdvancedMap_Objective_C-Swift.h"

/*
 * A controller for displaying sample list and launching the selected sample controller.
 */
@interface LauncherListController : UIViewController <GalleryDelegate>

-(NSArray *)samples;

@property MainView *contentView;

@end
