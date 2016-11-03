#import "MapBaseController.h"

/** OptionsMenu **/
@interface OptionsMenu : UIView

@property NTMapView *map;
@property NSMutableArray *views;

- (bool)isVisible;
- (void)hide;
- (void)show;
- (void)addItems:(NSArray *)items;

@end

/** OptionsMenuItem **/
@interface OptionsMenuItem : UIView

@property UIView *headerContainer;
@property UIView *contentContainer;

@property UILabel *osmLabel;
@property UILabel *tileTypeLabel;

@property NSMutableArray *optionLabels;

- (bool) isMultiLine;
- (void)setValues:(NSDictionary *)values;

@end

/** OptionLabel **/
@interface OptionLabel : UIView

- (void) setOption:(NSDictionary *)option;

@end

/** BaseMapsController **/
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
    [self.menu addItems: self.options];
    
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

-(NSArray*)options
{
    return @[
                 @{
                     @"OSM": @{ @"name": @"Nutiteq", @"value": @"nutiteq.osm" },
                     @"Type": @"Vector",
                     @"Styles": @[
                            @{ @"name": @"Bright", @"value": @"default" },
                            @{ @"name": @"Gray", @"value": @"gray" },
                            @{ @"name": @"Dark", @"value": @"dark" }
                        ]
                    },
                 @{
                     @"OSM": @{ @"name": @"Mapzen", @"value": @"mapzen.osm" },
                     @"Type": @"Vector",
                     @"Styles": @[
                             @{ @"name": @"Bright", @"value": @"styles_mapzen:style" },
                             @{ @"name": @"Positron", @"value": @"styles_mapzen:positron" },
                             @{ @"name": @"Dark Matter", @"value": @"styles_mapzen:positron_dark" }
                             ]
                     },
                 @{
                     @"OSM": @{ @"name": @"CARTO", @"value": @"carto.osm" },
                     @"Type": @"Raster",
                     @"Styles": @[
                             @{ @"name": @"Positron", @"value": @"positron" },
                             @{ @"name": @"Dark Matter", @"value": @"darkmater" }
                             ]
                     },
                 @{
                     @"OSM": @{ @"name": @"Language", @"value": @"lang" },
                     @"Type": @"Language",
                     @"Styles": @[
                             @{ @"name": @"English", @"value": @"en" },
                             @{ @"name": @"German", @"value": @"de" },
                             @{ @"name": @"Spanish", @"value": @"es" },
                             
                             @{ @"name": @"Italian", @"value": @"it" },
                             @{ @"name": @"French", @"value": @"fr" },
                             @{ @"name": @"Russian", @"value": @"ru" }
                             
                             // Chinese is supported, but disabled in our example,
                             // as it requires an extra asset package (nutibright-v3-full.zip)
                             // @{ @"name": @"Chineze", @"value": @"zh" }
                             ]
                     },
             
              ];
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

-(void)layoutSubviews
{
    float smallPading = 5;
    float largePadding = 20;
    
    float x = smallPading;
    float y = largePadding;
    float w = [self frame].size.width  - 2 * smallPading;
    float h = 0;
    
    int counter = 0;
    
    for (int i = 0; i < self.views.count; i++) {
        
        OptionsMenuItem *view = [self.views objectAtIndex:i];
        
        if ([view isMultiLine]) {
            h = 120;
        } else {
            h = 80;
        }
        
        [view setFrame:CGRectMake(x, y, w, h)];
        
        if (counter == 2) {
            y += h + largePadding;
        } else {
            y += h + smallPading;
        }
        
        counter++;
    }
}

- (void)onTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    [self hide];
}

- (bool)isVisible
{
    return [self superview] != nil;
}

- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)hide
{
    [self removeFromSuperview];
}

- (void) addItems:(NSArray *)items
{
    for (int i = 0; i < items.count; i++) {
        
        NSDictionary *item = [items objectAtIndex:i];
        
        OptionsMenuItem *view = [[OptionsMenuItem alloc] init];
        [view setValues: item];
        
        [self.views addObject:view];
        [self addSubview:view];
    }
}

@end

@implementation OptionsMenuItem

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [[self layer] setCornerRadius:5];
    
    self.headerContainer = [[UIView alloc] init];
    [self.headerContainer setBackgroundColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    [self addSubview:self.headerContainer];
    
    self.contentContainer = [[UIView alloc] init];
    [self.contentContainer setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    [self addSubview:self.contentContainer];
    
    self.osmLabel = [[UILabel alloc]init];
    [self.osmLabel setTextColor:[UIColor whiteColor]];
    [self.osmLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [self.osmLabel setTextAlignment:NSTextAlignmentJustified];
    
    self.tileTypeLabel = [[UILabel alloc]init];
    [self.tileTypeLabel setTextColor:[UIColor whiteColor]];
    [self.tileTypeLabel setFont:[UIFont systemFontOfSize:12]];
    [self.tileTypeLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.headerContainer addSubview:self.osmLabel];
    [self.headerContainer addSubview:self.tileTypeLabel];
    
    self.optionLabels = [[NSMutableArray alloc] init];
    
    return self;
}

-(void)layoutSubviews
{
    float headerHeight = 30;
    float itemHeight = 28;
    
    float padding = 10;
    float itemTopPadding = 11;
    
    [self.headerContainer setFrame:CGRectMake(0, 0, [self frame].size.width, headerHeight)];
    [self.contentContainer setFrame:CGRectMake(0, headerHeight, [self frame].size.width, [self frame].size.height - [self.headerContainer frame].size.height)];
    
    float x = padding;
    float y = 0;
    float w = [self.headerContainer frame].size.width / 2 - padding;
    float h = [self.headerContainer frame].size.height;
    
    [self.osmLabel setFrame:CGRectMake(x, y, w, h)];
    
    x += w + padding;

    [self.tileTypeLabel setFrame:CGRectMake(x, y, w, h)];
}

- (bool)isMultiLine
{
    return self.optionLabels.count > 3;
}

- (void)setValues:(NSDictionary *)values
{
    NSDictionary *osm = [values objectForKey:@"OSM"];
    NSString *type = [values objectForKey:@"Type"];
    NSArray *options = [values objectForKey:@"Styles"];

    self.osmLabel.text = [osm valueForKey:@"name"];
    self.tileTypeLabel.text = type;
    
    for (int i = 0; i < options.count; i++) {
        NSDictionary *option = [options objectAtIndex:i];
        
        OptionLabel *label = [[OptionLabel alloc] init];
        [label setOption:option];

        [self.optionLabels addObject:label];
        [self addSubview:label];
    }
}

@end

@implementation OptionLabel

- (void) setOption:(NSDictionary *)option
{

}

@end






