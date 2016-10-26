
#import "MapSampleBaseController.h"

@interface CaptureController : MapSampleBaseController

@end

@interface RendererListener : NTRendererCaptureListener

@property NTMapPos* position;
@property int* number;

@property NTMapView* mapView;

@end

@implementation CaptureController

-(void) viewDidLoad
{
    // Initialize projection and data source
    NTProjection* projection = [[self.mapView getOptions] getBaseProjection];
    NTLocalVectorDataSource* source = [[NTLocalVectorDataSource alloc]initWithProjection:projection];
    
    // Intialize a vector layer for our marker
    NTVectorLayer* layer = [[NTVectorLayer alloc] initWithDataSource:source];
    [[self.mapView getLayers] add:layer];
    
    // Load bitmap
    UIImage* image = [UIImage imageNamed:@"marker"];
    NTBitmap* bitmap = [NTBitmapUtils createBitmapFromUIImage: image];
    
    // Create a marker
    NTMarkerStyleBuilder* builder = [[NTMarkerStyleBuilder alloc] init];
    [builder setBitmap:bitmap];
    [builder setSize:30];
    
    NTMapPos* coordinates = [[NTMapPos alloc] initWithX:13.38933 y:52.51704];
    NTMapPos* berlin = [projection fromWgs84:coordinates];
    
    NTMarker* marker = [[NTMarker alloc] initWithPos:berlin style: [builder buildStyle]];
    [source add:marker];
    
    // Animate zoom to position
    [self.mapView setFocusPos:berlin durationSeconds:1];
    [self.mapView setZoom:12 durationSeconds:1];
    
    // Initialize renderer
    RendererListener* listener = [[RendererListener alloc] init];
    listener.mapView = self.mapView;
    listener.number = 0;
    listener.position = [[NTMapPos alloc]init];
    [[self.mapView getMapRenderer] captureRendering:listener waitWhileUpdating:true];
}

@end

@implementation RendererListener

-(void) onMapRendered:(NTBitmap *)bitmap
{
    if (![[self.mapView getFocusPos] isEqualInternal:self.position]) {
        
        self.position = [self.mapView getFocusPos];
        self.number++;
        
        UIImage *image = [NTBitmapUtils createUIImageFromBitmap:bitmap];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        path = [path stringByAppendingFormat:@"%d", self.number];
        
        NSData* data = UIImagePNGRepresentation(image);
        
        BOOL *success = [data writeToFile:path atomically:YES];
        
        if (success) {
            NSLog([@"Great success! Image saved to " stringByAppendingString:path]);
        } else {
            NSLog([@"Unable to save image to " stringByAppendingString:path]);
        }
    }
}

@end










