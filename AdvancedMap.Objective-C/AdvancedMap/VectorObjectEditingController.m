
#import "MapBaseController.h"
#import "VectorElementSelectEventListener.h"
#import "VectorElementDeselectEventListener.h"
#import "BasicEditEventListener.h"

@interface VectorObjectEditingController : MapBaseController

@end

@implementation VectorObjectEditingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.contentView addBaseLayer: NT_CARTO_BASEMAP_STYLE_VOYAGER];
    
    NTProjection* projection = [[self.contentView.mapView getOptions] getBaseProjection];
    NTLocalVectorDataSource* source = [[NTLocalVectorDataSource alloc] initWithProjection:projection];
    
    // Initialize edit layer
    NTEditableVectorLayer* editLayer = [[NTEditableVectorLayer alloc] initWithDataSource:source];
    [[self.contentView.mapView getLayers] add:editLayer];
    
    // Add some elements that we can change and move
    [self addPoint:source];
    [self addLine:source];
    [self addPolygon:source];
    
    // Add a vector element even listener to select elements (on element click)
    VectorElementSelectEventListener* selectListener = [[VectorElementSelectEventListener alloc]init];
    selectListener.vectorLayer = editLayer;
    [editLayer setVectorElementEventListener:selectListener];
    
    // Add a map even listener to deselect element (on map click)
    VectorElementDeselectEventListener* deselectListener = [[VectorElementDeselectEventListener alloc]init];
    deselectListener.vectorLayer = editLayer;
    [self.contentView.mapView setMapEventListener:deselectListener];
    
    // Add the vector element edit even listener
    BasicEditEventListener* editListener = [[BasicEditEventListener alloc]init];
    editListener.source = source;
    [editLayer setVectorEditEventListener:editListener];
}

-(void) addPoint:(NTLocalVectorDataSource *)source
{
    NTMapPos* position = [[NTMapPos alloc] initWithX:-5000000 y:-900000];
    
    NTPointStyleBuilder* builder = [[NTPointStyleBuilder alloc] init];
    NTColor* color = [[NTColor alloc] initWithR:0 g:0 b:255 a:255];
    [builder setColor: color];
    
    NTPoint* point = [[NTPoint alloc]initWithPos:position style:[builder buildStyle]];
    
    [source add:point];
}

-(void) addLine:(NTLocalVectorDataSource *)source
{
    NTMapPosVector* points = [[NTMapPosVector alloc] init];
    [points add:[[NTMapPos alloc] initWithX:-6000000 y:-500000]];
    [points add:[[NTMapPos alloc] initWithX:-9000000 y:-500000]];
    
    NTLineStyleBuilder* builder = [[NTLineStyleBuilder alloc]init];
    NTColor* color = [[NTColor alloc] initWithR:255 g:0 b:0 a:255];
    [builder setColor: color];
    
    NTLine* line = [[NTLine alloc]initWithPoses:points style:[builder buildStyle]];
    
    [source add:line];
}

-(void) addPolygon:(NTLocalVectorDataSource *)source
{
    NTMapPosVector* points = [[NTMapPosVector alloc] init];
    [points add:[[NTMapPos alloc] initWithX:-5000000 y:-5000000]];
    [points add:[[NTMapPos alloc] initWithX:5000000 y:-5000000]];
    [points add:[[NTMapPos alloc] initWithX:0 y:10000000]];
    
    NTPolygonStyleBuilder* builder = [[NTPolygonStyleBuilder alloc]init];
    NTColor* color = [[NTColor alloc] initWithR:0 g:255 b:0 a:255];
    [builder setColor: color];
    
    NTPolygon* polygon = [[NTPolygon alloc]initWithPoses:points style:[builder buildStyle]];
    
    [source add:polygon];
}

@end










