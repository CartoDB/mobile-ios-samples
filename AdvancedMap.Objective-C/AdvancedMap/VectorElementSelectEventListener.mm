
#import "VectorElementSelectEventListener.h"

@implementation VectorElementSelectEventListener

-(BOOL) onVectorElementClicked:(NTVectorElementClickInfo *)clickInfo
{
    NTVectorElement* element = [clickInfo getVectorElement];
    [self.vectorLayer setSelectedVectorElement:element];
    
    return YES;
}

@end
