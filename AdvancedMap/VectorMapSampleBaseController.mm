#import "VectorMapSampleBaseController.h"
#import "VPPDropDown.h"
#import "VPPDropDownDelegate.h"

@interface DropDownMenuController : UITableViewController <VPPDropDownDelegate, UIActionSheetDelegate>

- (id)initWithStyle:(UITableViewStyle)style controller:(VectorMapSampleBaseController*)sampleController;

@property VPPDropDown* dropDownLanguage;
@property VPPDropDown* dropDownStyle;
@property(weak) VectorMapSampleBaseController* sampleController;

@end

@implementation VectorMapSampleBaseController

-(NSDictionary*)languages
{
    return @{
             @"local": @"",
             @"English": @"en",
             @"German":  @"de",
             @"Spanish": @"es",
             @"Italian": @"it",
             @"French":  @"fr",
             @"Russian": @"ru",
             @"Chinese": @"zh",
             @"Estonian": @"et",
             };
}

-(NSDictionary*)styles
{
    return @{
             @"Basic":		   @"basic",
             @"NutiBright 2D": @"nutibright-v2a",
             @"Nutiteq dark": @"nutiteq-dark",
             @"NutiBright 3D": @"nutibright3d",
             @"Loose Leaf":	   @"looseleaf"
             };
}

- (void)showMenu
{
    DropDownMenuController* menuController = [[DropDownMenuController alloc] initWithStyle:UITableViewStylePlain controller:self];
    [self.navigationController pushViewController:menuController animated:YES];
}

- (void)createMenu
{
    UIImage* menuImage = [UIImage imageNamed:@"menu.png"];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target: self action: @selector(showMenu)];
    [self.navigationItem setRightBarButtonItem: menuButton];
}

- (void)updateBaseLayer
{
    // Load vector tile styleset
    NSString* styleAssetName = [self.vectorStyleName stringByAppendingString: @".zip"];
    BOOL styleBuildings3D = NO;
    if ([self.vectorStyleName isEqualToString:@"nutibright3d"]) {
        styleAssetName = @"nutibright-v2a.zip";
        styleBuildings3D = YES;
    }
    NTBinaryData *vectorTileStyleSetData = [NTAssetUtils loadAsset:styleAssetName];
    NTZippedAssetPackage* assetPackage = [[NTZippedAssetPackage alloc] initWithZipData:vectorTileStyleSetData];
    NTCompiledStyleSet *vectorTileStyleSet = [[NTCompiledStyleSet alloc] initWithAssetPackage:assetPackage];
    
    // Create vector tile decoder using the styleset and update style parameters
    self.vectorTileDecoder = [[NTMBVectorTileDecoder alloc] initWithCompiledStyleSet:vectorTileStyleSet];
    [self.vectorTileDecoder setStyleParameter:@"lang" value:self.vectorStyleLanguage];
    if ([styleAssetName isEqualToString:@"nutibright-v2a.zip"] && styleBuildings3D) { // only OSM Bright style supports this currently
        [self.vectorTileDecoder setStyleParameter:@"buildings3d" value:@"1"];
    }
    
    [self.vectorTileDecoder setStyleParameter:@"markers3d" value:@"1"];
    [self.vectorTileDecoder setStyleParameter:@"texts3d" value:@"1"];
    [self.vectorTileDecoder setStyleParameter:@"shields3d" value:@"1"];

    
    // special parameters for elevation contour style
    [self.vectorTileDecoder setStyleParameter:@"contour_stroke" value:@"rgba(217, 166, 140, 0.53)"];
    [self.vectorTileDecoder setStyleParameter:@"contour_width" value:@"0.8"];
    
    // Create tile data source
    if (!self.vectorTileDataSource) {
        self.vectorTileDataSource = [self createTileDataSource];
    }
    
    // Create vector tile layer, using previously created data source and decoder
    if (self.baseLayer) {
        [[self.mapView getLayers] remove:self.baseLayer];
    }
    self.baseLayer = [[NTVectorTileLayer alloc] initWithDataSource:self.vectorTileDataSource decoder:self.vectorTileDecoder];
    
    // Add vector tile layer
    [[self.mapView getLayers] insert:0 layer:self.baseLayer];
}

- (NTTileDataSource*)createTileDataSource
{
    // Create global online vector tile data source
    NTTileDataSource *vectorTileDataSource = [[NTCartoOnlineTileDataSource alloc] initWithSource:@"nutiteq.osm"];
    
    // We don't use vectorTileDataSource directly (this would be also option),
    // but via caching to cache data locally non-persistently
    NTTileDataSource* cacheDataSource = [[NTCompressedCacheTileDataSource alloc] initWithDataSource:vectorTileDataSource];
    return cacheDataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NTLog setShowDebug:true];
    [NTLog setShowInfo:true];
    
    // Set the base projection, that will be used for most MapView, MapEventListener and Options methods
    NTEPSG3857* proj = [[NTEPSG3857 alloc] init];
    [[self.mapView getOptions] setBaseProjection:proj];
    
    // Set initial location and other parameters, don't animate
    [self.mapView setFocusPos:[proj fromWgs84:[[NTMapPos alloc] initWithX:24.650415 y:59.428773]]  durationSeconds:0];
    [self.mapView setZoom:14 durationSeconds:0];
    [self.mapView setRotation:0 durationSeconds:0];
    
    // Set default style parameters and create base layer
    self.vectorStyleName = @"nutibright-v2a";
    self.vectorStyleLanguage = @"";
    [self updateBaseLayer];
    
    // Create menu
    [self createMenu];
}

@end

@implementation DropDownMenuController

- (id)initWithStyle:(UITableViewStyle)style controller:(VectorMapSampleBaseController*)sampleController
{
    self = [super initWithStyle:style];
    if (self) {
        self.sampleController = sampleController;
        
        // Custom initialization
        NSInteger selectedLanguage = [[[sampleController languages] allValues] indexOfObject:sampleController.vectorStyleLanguage];
        _dropDownLanguage = [[VPPDropDown alloc] initSelectionWithTitle:@"Language"
                                                              tableView:self.tableView
                                                              indexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                               delegate:self
                                                          selectedIndex:(int)selectedLanguage
                                                          elementTitles:[[sampleController languages] allKeys]];
        
        NSInteger selectedStyle = [[[sampleController styles] allValues] indexOfObject:sampleController.vectorStyleName];
        _dropDownStyle = [[VPPDropDown alloc] initSelectionWithTitle:@"Style"
                                                           tableView:self.tableView
                                                           indexPath:[NSIndexPath indexPathForRow:1 inSection:0]
                                                            delegate:self
                                                       selectedIndex:(int)selectedStyle
                                                       elementTitles:[[sampleController styles] allKeys]];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rows = [VPPDropDown tableView:tableView numberOfExpandedRowsInSection:section];
    rows += 2; // 2 sections: language, style
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([VPPDropDown tableView:tableView dropdownsContainIndexPath:indexPath]) {
        return [VPPDropDown tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([VPPDropDown tableView:tableView dropdownsContainIndexPath:indexPath]) {
        [VPPDropDown tableView:tableView didSelectRowAtIndexPath:indexPath];
        return;
    }
}

- (void) dropDown:(VPPDropDown *)dropDown elementSelected:(VPPDropDownElement *)element atGlobalIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[self tableView] cellForRowAtIndexPath:indexPath];
    if (dropDown == _dropDownLanguage) {
        self.sampleController.vectorStyleLanguage = [[self.sampleController languages] objectForKey:cell.textLabel.text];
        [self.sampleController updateBaseLayer];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (dropDown == _dropDownStyle) {
        self.sampleController.vectorStyleName = [[self.sampleController styles] objectForKey:cell.textLabel.text];
        [self.sampleController updateBaseLayer];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
