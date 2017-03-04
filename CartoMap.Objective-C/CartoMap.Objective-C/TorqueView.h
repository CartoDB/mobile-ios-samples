
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CartoMobileSDK/CartoMobileSDK.h>
#import "TorqueHistogram.h"

@interface TorqueView : UIView

@property (nonatomic,strong) NTMapView *MapView;

@property TorqueHistogram *Histogram;

@end
