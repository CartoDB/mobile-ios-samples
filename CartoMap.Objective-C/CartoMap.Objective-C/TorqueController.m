
#import "MapBaseController.h"
#import "TorqueView.h"

@interface TorqueController : UIViewController

@property NTTorqueTileDecoder* decoder;
@property NTTorqueTileLayer* torqueLayer;

@property TorqueView *contentView;

@property NSTimer* timer;

-(NTTorqueTileLayer*)getTorqueLayer;

@end

@implementation TorqueController

-(NTTorqueTileLayer*)getTorqueLayer
{
    if (self.torqueLayer != nil)
    {
        return self.torqueLayer;
    }
    
    for (int i = 0; i < [[self.contentView.MapView getLayers] count]; i++)
    {
        NTLayer *layer = [[self.contentView.MapView getLayers] get:i];
        
        if ([layer class] == [NTTorqueTileLayer class])
        {
            self.torqueLayer = (NTTorqueTileLayer*)layer;
            self.decoder = (NTTorqueTileDecoder*)[self.torqueLayer getTileDecoder];
            return self.torqueLayer;
        }
    }
    
    return nil;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    NSString *username = @"solutions";
    NSString *mapname = @"tpl_a108ee2b_6699_43bc_aa71_3b0bc962acf9";
    BOOL isVector = NO;
    
    self.contentView = [[TorqueView alloc]init];
    self.view = self.contentView;
    
    NTCartoMapsService *service = [[NTCartoMapsService alloc]init];
    [service setUsername:username];
    [service setDefaultVectorLayerMode:isVector];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
    
        NTLayerVector *layers = [service buildNamedMap:mapname templateParams:[[NTStringVariantMap alloc]init]];
        
        // NB! This update priority only works for the map tpl_a108ee2b_6699_43bc_aa71_3b0bc962acf9
        // It may make loading worse or even break it when tried with other maps
        [[layers get:0] setUpdatePriority:2];
        [[layers get:1] setUpdatePriority:1];
        [[layers get:2] setUpdatePriority:0];
        
        for (int i = 0; i < [layers size]; i++) {
            NTLayer *layer = [layers get:i];
            [[self.contentView.MapView getLayers] add:layer];
        }

    });

    NTMapPos *position = [[NTMapPos alloc] initWithX:0.0013 y:0.0013];
    NTMapPos *center = [[[self.contentView.MapView getOptions] getBaseProjection ] fromWgs84:position];
    [self.contentView.MapView setFocusPos:center durationSeconds:0];
    [self.contentView.MapView setZoom:18.0f durationSeconds:0];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTorque:) userInfo:nil repeats:YES];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}

-(void) updateTorque:(NSTimer*)timer
{
    if (self.torqueLayer == nil) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int frame = ([self.torqueLayer getFrameNr] + 1) % [self.decoder getFrameCount];
        [self.torqueLayer setFrameNr:frame];
        
    });
}

@end






