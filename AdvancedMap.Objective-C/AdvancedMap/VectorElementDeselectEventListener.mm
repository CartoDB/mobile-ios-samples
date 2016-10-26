
#import "VectorElementDeselectEventListener.h"

@implementation VectorElementDeselectEventListener

-(void) onMapClicked:(NTMapClickInfo *)mapClickInfo
{
    [self.vectorLayer setSelectedVectorElement:nil];
}

@end