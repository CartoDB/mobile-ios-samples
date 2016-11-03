#import "MapBaseController.h"

@interface OptionsMenu : UIView

@property NTMapView *map;
@property NSMutableArray *views;

-(bool) isVisible;
-(void) hide;
-(void) show;

@end

@interface BaseMapsController : MapBaseController

@property OptionsMenu *menu;
@property UIBarButtonItem *menuButton;

@end

@implementation BaseMapsController

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGSize size = [[UIScreen mainScreen] bounds].size;
    self.menu = [[OptionsMenu alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    self.menu.map = self.mapView;
    
    UIImageView *view = [[UIImageView alloc]init];
    [view setImage:[UIImage imageNamed:@"icon_more"]];
    [view setFrame:CGRectMake(0, 10, 20, 30)];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [view addGestureRecognizer:recognizer];
    
    self.menuButton = [[UIBarButtonItem alloc]init];
    [self.menuButton setCustomView:view];
    
    [[self navigationItem] setRightBarButtonItem:self.menuButton];
}

- (void)onTap:(UITapGestureRecognizer *)recognizer
{
    if ([self.menu isVisible]) {
        [self.menu hide];
    } else {
        [self.menu show];
    }
}

- (void)updateBaseLayer
{

}

@end

@implementation OptionsMenu

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.views = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:recognizer];
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    return self;
}

-(void) layoutSubviews
{
    float smallPading = 5;
    float largePadding = 20;
}

- (void)onTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    [self hide];
}

- (bool) isVisible
{
    return [self superview] != nil;
}

- (void) show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void) hide
{
    [self removeFromSuperview];
}

@end







