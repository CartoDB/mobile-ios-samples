
#import "VectorElementSelectEventListener.h"

@implementation VectorElementSelectEventListener

-(bool) onVectorElementClicked:(NTVectorElementClickInfo *)clickInfo
{
    NTVectorElement* element = [clickInfo getVectorElement];
    [self.vectorLayer setSelectedVectorElement:element];
    
    return true;
}

@end