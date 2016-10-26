
#import "BasicEditEventListener.h"

@implementation BasicEditEventListener

-(void) onElementModify:(NTVectorElement *)element geometry:(NTGeometry *)geometry
{
    if ([element isKindOfClass:[NTPoint class]]) {
        [((NTPoint *)element) setGeometry:(NTPointGeometry *)geometry];
    } else if ([element isKindOfClass:[NTLine class]]) {
        [((NTLine *)element) setGeometry:(NTLineGeometry *)geometry];
    } else if ([element isKindOfClass:[NTPolygon class]]) {
        [((NTPolygon *)element) setGeometry:(NTPolygonGeometry *)geometry];
    }
}

-(void) onElementDelete:(NTVectorElement *)element
{
}

-(NTVectorElementDragResult) onDragStart:(NTVectorElementDragInfo *)dragInfo
{
    return NT_VECTOR_ELEMENT_DRAG_RESULT_MODIFY;
}

-(NTVectorElementDragResult) onDragMove:(NTVectorElementDragInfo *)dragInfo
{
    return NT_VECTOR_ELEMENT_DRAG_RESULT_MODIFY;
}

-(NTVectorElementDragResult) onDragEnd:(NTVectorElementDragInfo *)dragInfo
{
    return NT_VECTOR_ELEMENT_DRAG_RESULT_MODIFY;
}

-(NTPointStyle *) onSelectDragPointStyle:(NTVectorElement *)element dragPointStyle:(enum NTVectorElementDragPointStyle)dragPointStyle
{
    if (self.styleNormal == nil) {
        NTPointStyleBuilder* builder = [[NTPointStyleBuilder alloc] init];
        [builder setColor:[[NTColor alloc]initWithR:0 g:255 b:255 a:255]];
        [builder setSize:20];
        
        self.styleNormal = [builder buildStyle];
        
        [builder setSize:15];
        
        self.styleVirtual = [builder buildStyle];
        
        [builder setColor:[[NTColor alloc]initWithR:255 g:255 b:0 a:255]];
        [builder setSize:30];
        
        self.styleSelected = [builder buildStyle];
    }
    
    return self.styleNormal;
}

@end