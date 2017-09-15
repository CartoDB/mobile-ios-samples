
#import "MapBaseController.h"
#import "VectorTileListener.h"
#import "Sources.h"

/** OptionLabel **/
@interface OptionLabel : UILabel

@property NSString *name;
@property NSString *value;

- (void)setOption:(NSDictionary *)option;

- (void)highlight;
- (void)normalize;

@end

/** OptionsMenu **/
@interface OptionsMenu : UIView

@property NTMapView *map;
@property NSMutableArray *views;

@property MapBaseController *controller;

@property OptionLabel *currentHighlight;
@property OptionLabel *currentLanguageHighlight;

- (bool)isVisible;
- (void)hide;
- (void)show;
- (void)addItems:(NSArray *)items;
- (void)setInitialValues;

- (void)resetLanguage;

@end

/** OptionsMenuItem **/
@interface OptionsMenuItem : UIView

@property UIView *headerContainer;
@property UIView *contentContainer;

@property UILabel *osmLabel;
@property UILabel *tileTypeLabel;

@property NSMutableArray *optionLabels;

@property NSString *OSMValue;
@property NSString *typeValue;

- (bool) isMultiLine;
- (int) lineCount;

- (void)setValues:(NSDictionary *)values;

@end

/** BaseMapsController **/
@interface BaseMapsController : MapBaseController

@property OptionsMenu *menu;
@property UIBarButtonItem *menuButton;
@property UITapGestureRecognizer *recognizer;

@property NTVectorLayer *vectorLayer;

@property VectorTileListener *listener;

- (void)updateBaseLayer:(NSString *)osm :(NSString *)type :(NSString *)style;

@end

@implementation BaseMapsController

NSString *currentOSM;
NSString *currentSelection;
NTTileLayer *currentLayer;

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *view = [[UIImageView alloc]init];
    [view setImage:[UIImage imageNamed:@"icon_more"]];
    [view setFrame:CGRectMake(0, 10, 20, 30)];
    
    self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [view addGestureRecognizer:self.recognizer];
    
    self.menuButton = [[UIBarButtonItem alloc]init];
    [self.menuButton setCustomView:view];
    
    [[self navigationItem] setRightBarButtonItem:self.menuButton];
    
    // Zoom to Central Europe so some texts would be visible
    NTMapPos *position = [[NTMapPos alloc] initWithX:15.2551 y:54.5260];
    position = [[[self.contentView.mapView getOptions] getBaseProjection] fromWgs84:position];
    
    [self.contentView.mapView setFocusPos:position durationSeconds:0];
    [self.contentView.mapView setZoom:5 durationSeconds:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    self.menu = [[OptionsMenu alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    self.menu.map = self.contentView.mapView;
    self.menu.controller = self;
    
    [self.menu addItems: self.options];
    
    // Set initial values visually on the menu
    [self.menu setInitialValues];
    
    // Default values for osm, tiletype and style, respectively
    [self updateBaseLayer:CARTO_VECTOR_SOURCE :@"Vector" :@"voyager"];
    
    // Default language
    [self updateLanguage:@""];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Manually release menu, as it is not added to the controller's view hierarchy,
    // but directly to the keyWindow
    self.menu = nil;
    
    self.listener = nil;
    self.vectorLayer = nil;
    [self updateListener];
}

- (void)onTap:(UITapGestureRecognizer *)recognizer
{
    if ([self.menu isVisible]) {
        [self.menu hide];
    } else {
        [self.menu show];
    }
}

- (void)updateBaseLayer:(NSString *)osm :(NSString *)type :(NSString *)style
{
    if (![type isEqual: @"Language"]) {
        currentOSM = osm;
        currentSelection = style;
    }
    
    if ([type isEqualToString:@"Vector"]) {
        
        if ([currentOSM isEqualToString:CARTO_VECTOR_SOURCE]) {
            
            if ([currentSelection isEqualToString:@"voyager"]) {
                currentLayer  = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_VOYAGER];
            } else if ([currentSelection isEqualToString:@"positron"]) {
                currentLayer  = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_POSITRON];
            } else if ([currentSelection isEqualToString:@"darkmatter"]) {
                currentLayer  = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_DARKMATTER];
            }
        } else if ([currentOSM isEqualToString:MAPZEN_SOURCE]) {
            
            NSString *fileName = [[currentSelection componentsSeparatedByString:@":"] objectAtIndex:0];
            NSString *styleName = [[currentSelection componentsSeparatedByString:@":"] objectAtIndex:1];
            
            NTBinaryData *styleAsset = [NTAssetUtils loadAsset:[fileName stringByAppendingString: @".zip"]];
            NTZippedAssetPackage *package = [[NTZippedAssetPackage alloc] initWithZipData:styleAsset];
            NTCompiledStyleSet *set = [[NTCompiledStyleSet alloc] initWithAssetPackage:package styleName:styleName];
            
            NTCartoOnlineTileDataSource *source = [[NTCartoOnlineTileDataSource alloc] initWithSource:currentOSM];
            NTMBVectorTileDecoder *decoder = [[NTMBVectorTileDecoder alloc] initWithCompiledStyleSet:set];
            
            currentLayer = [[NTVectorTileLayer alloc] initWithDataSource:source decoder:decoder];
        }
        
        [self resetLanguage];
        
    } else if ([type isEqualToString:@"Raster"]) {
        
        NSString *url = @"";
        
        if ([currentSelection isEqualToString:@"positron"]) {
            url = @"http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png";
        } else {
            url = @"http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png";
        }
        
        NTTileDataSource *source = [[NTHTTPTileDataSource alloc] initWithMinZoom:1 maxZoom:19 baseURL:url];
        currentLayer = [[NTRasterTileLayer alloc] initWithDataSource:source];
        
    } else if ([type isEqualToString:@"Language"]) {
        [self updateLanguage:style];
    }
    
    [[self.contentView.mapView getLayers] clear];
    [[self.contentView.mapView getLayers] add:currentLayer];
    
    [self initializeVectorTileListener];
}


- (void)initializeVectorTileListener
{
    if (self.vectorLayer == nil) {
        NTProjection *projection = [[self.contentView.mapView getOptions]getBaseProjection];
        NTLocalVectorDataSource *source = [[NTLocalVectorDataSource alloc]initWithProjection:projection];
        self.vectorLayer = [[NTVectorLayer alloc]initWithDataSource:source];
    } else {
        [[self.contentView.mapView getLayers] remove:self.vectorLayer];
    }

    [[self.contentView.mapView getLayers] add:self.vectorLayer];
    
    [self updateListener];
}

- (void)updateListener
{
    NTLayer *layer = [[self.contentView.mapView getLayers] get:0];
    
    if ([layer isKindOfClass:NTVectorTileLayer.class]) {
        if (self.listener == nil) {
            self.listener = [[VectorTileListener alloc]init];
        }
        
        self.listener.vectorLayer = self.vectorLayer;
        [((NTVectorTileLayer *)layer) setVectorTileEventListener:self.listener];
    }
}

- (void)resetLanguage
{
    [self.menu resetLanguage];
    [self updateLanguage:@""];
}

- (void)updateLanguage:(NSString *)code
{
    if (currentLayer == nil) {
        return;
    }
    
    if ([currentLayer isKindOfClass:NTRasterTileLayer.class]) {
        // Raster tile language chance is not supported
        return;
    }
    
    NTVectorTileLayer *layer = (NTVectorTileLayer *)currentLayer;
    NTMBVectorTileDecoder *decoder = (NTMBVectorTileDecoder *)[layer getTileDecoder];
    
    [decoder setStyleParameter:@"lang" value:code];
}

-(NSArray*)options
{
    return @[
                 @{
                     @"OSM": @{ @"name": @"Carto Vector", @"value": CARTO_VECTOR_SOURCE },
                     @"Type": @"Vector",
                     @"Styles": @[
                            @{ @"name": @"Voyager", @"value": @"voyager" },
                            @{ @"name": @"Positron", @"value": @"positron" },
                            @{ @"name": @"Darkmatter", @"value": @"darkmatter" }
                        ]
                    },
                 @{
                     @"OSM": @{ @"name": @"Mapzen", @"value": MAPZEN_SOURCE },
                     @"Type": @"Vector",
                     @"Styles": @[
                             @{ @"name": @"Bright", @"value": @"styles_mapzen:style" },
                             @{ @"name": @"Positron", @"value": @"styles_mapzen:positron" },
                             @{ @"name": @"Dark Matter", @"value": @"styles_mapzen:positron_dark" }
                             ]
                     },
                 @{
                     @"OSM": @{ @"name": @"Carto Raster", @"value": CARTO_RASTER_SOURCE },
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
                             @{ @"name": @"Default", @"value": @"" },
                             
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

-(void)setInitialValues
{
    // nutiteq. osm is our default baselayer. set it visually in the menu
    OptionsMenuItem *item = [self.views objectAtIndex:0];
    OptionLabel *label = [item.optionLabels objectAtIndex:0];
    [label highlight];
    
    self.currentHighlight = label;
    
    [self resetLanguage];
}

- (void)resetLanguage
{
    // Set Default as default language
    OptionsMenuItem *item = [self.views objectAtIndex:3];
    
    for (int i = 0; i < item.optionLabels.count; i++) {
        [[item.optionLabels objectAtIndex:i] normalize];
    }
    
    OptionLabel *label = [item.optionLabels objectAtIndex:0];
    [label highlight];
    
    self.currentLanguageHighlight = label;
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
        
        h = [view lineCount] * 40 + 40;
        
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
    
    CGPoint location = [recognizer locationInView:recognizer.view];

    for (int i = 0; i < self.views.count; i++) {
        OptionsMenuItem *view = [self.views objectAtIndex:i];

        if (CGRectContainsPoint([view frame], location)) {
            
            CGPoint transformed = [self convertPoint:location toView:view.contentContainer];

            for (int j = 0; j < view.optionLabels.count; j++) {
                
                OptionLabel *label = [view.optionLabels objectAtIndex:j];
                
                if (CGRectContainsPoint([label frame], transformed)) {
                    
                    if ([view.typeValue isEqualToString:@"Language"]) {
                    
                        if (self.currentLanguageHighlight != nil) {
                            [self.currentLanguageHighlight normalize];
                        }
                    } else {
                        
                        if (self.currentHighlight != nil) {
                            [self.currentHighlight normalize];
                        }
                    }
                    
                    [label highlight];
                    
                    if ([view.typeValue isEqualToString:@"Language"]) {
                        self.currentLanguageHighlight = label;
                    } else {
                        self.currentHighlight = label;
                    }
                    
                    // Language choice not supported on raster maps
                    if ([view.OSMValue  isEqual: @"carto.osm"]) {
                        [[self getLanguageBox] setHidden:true];
                    } else {
                        [[self getLanguageBox] setHidden:false];
                    }
                    
                    [((BaseMapsController *)self.controller) updateBaseLayer:view.OSMValue:view.typeValue:label.value];
                }
            }
        }
    }

    [self hide];
}

- (OptionsMenuItem *)getLanguageBox
{
    for (int i = 0; i < self.views.count; i++) {
        OptionsMenuItem *view = [self.views objectAtIndex:i];
        
         if ([view.typeValue isEqualToString:@"Language"]) {
             return view;
         }
    }
    
    return nil;
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
    
    self.layer.cornerRadius = 5;
    
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
    
    x = padding;
    y = itemTopPadding;
    h = itemHeight;
    
    if ([self isMultiLine]) {
        
        w = ([self.contentContainer frame].size.width - 4 * padding) / 3;
        
        int counter = 0;
        
        for (int i = 0; i < self.optionLabels.count; i++) {
            
            OptionLabel *label = [self.optionLabels objectAtIndex:i];
            
            if (counter > 0 && counter % 3 == 0) {
                y += h + padding;
                x = padding;
            }
            
            [label setFrame:CGRectMake(x, y, w, h)];
            x += w + padding;
            
            counter++;
        }
    } else {
        
        w = ([self.contentContainer frame].size.width - (padding + self.optionLabels.count * padding)) / self.optionLabels.count;
        
        for (int i = 0; i < self.optionLabels.count; i++) {
            
            OptionLabel *label = [self.optionLabels objectAtIndex:i];
            
            [label setFrame:CGRectMake(x, y, w, h)];
            x += w + padding;
        }
    }
}

- (bool)isMultiLine
{
    return self.optionLabels.count > 3;
}

- (int)lineCount
{
    if (self.optionLabels.count < 4) {
        return 1;
    }
    
    if (self.optionLabels.count < 7) {
        return 2;
    }
    
    return 3;
}

- (void)setValues:(NSDictionary *)values
{
    NSDictionary *osm = [values objectForKey:@"OSM"];
    NSString *type = [values objectForKey:@"Type"];
    NSArray *options = [values objectForKey:@"Styles"];
    
    self.OSMValue = [osm valueForKey:@"value"];
    self.typeValue = type;
    
    self.osmLabel.text = [osm valueForKey:@"name"];
    
    self.tileTypeLabel.text = type;
    
    for (int i = 0; i < options.count; i++) {
        NSDictionary *option = [options objectAtIndex:i];
        
        OptionLabel *label = [[OptionLabel alloc] init];
        [label setOption:option];

        [self.optionLabels addObject:label];
        [self.contentContainer addSubview:label];
    }
}

@end

@implementation OptionLabel

- (id)init
{
    self = [super init];
    
    [self setTextAlignment:NSTextAlignmentCenter];
    
    [self setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
    
    [self.layer setBorderWidth:0.5f];
    
    return self;
}

- (void) highlight
{
    UIColor *appleblue = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1];
    
    [self setBackgroundColor:appleblue];
    [[self layer] setBorderColor:[appleblue CGColor]];
    [self setTextColor:[UIColor whiteColor]];
    
    NSLog(@"Highlighting %@ - %@", self.name, self.value);
}

- (void)normalize
{
    UIColor *darkgray = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
    
    [self setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    [[self layer] setBorderColor:[darkgray CGColor]];
    [self setTextColor:darkgray];
    
    NSLog(@"Normalizing %@ - %@", self.name, self.value);
}

- (void) setOption:(NSDictionary *)option
{
    self.name = [option objectForKey:@"name"];
    self.value = [option objectForKey:@"value"];
    
    self.text = self.name;
}

@end






