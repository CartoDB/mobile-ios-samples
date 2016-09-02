
#import "VectorMapBaseController.h"
#import "VPPDropDown.h"
#import "VPPDropDownDelegate.h"

@interface DropDownMenuController : UITableViewController <VPPDropDownDelegate, UIActionSheetDelegate>

- (id)initWithStyle:(UITableViewStyle)style controller:(VectorMapBaseController*)sampleController;

@property VPPDropDown* dropDownLanguage;
@property VPPDropDown* dropDownStyle;
@property(weak) VectorMapBaseController* sampleController;

@end

@implementation VectorMapBaseController

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
             @"NutiBright 2D": @"nutibright-v3:default",
             @"Nutiteq dark": @"nutibright-v3:nutiteq_dark",
             @"Nutiteq grey": @"nutibright-v3:nutiteq_grey",
             @"NutiBright 3D": @"nutibright3d",
             @"Loose Leaf":	   @"looseleaf",
             @"MapZen":        @"mapzen",
             @"Positron@Mapzen": @"positron",
             @"Positron@Basemaps": @"cartodark"
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
    NTCompiledStyleSet *vectorTileStyleSet;
    
    BOOL styleBuildings3D = NO;
    
    NSString *vectorStyle = self.vectorStyleName;
    
    if ([vectorStyle isEqualToString:@"nutibright3d"]) {
        vectorStyle = @"nutibright-v3:default";
        styleBuildings3D = YES;
    }
    
    if([vectorStyle containsString:@":"]) {
        
        // Load vector tile styleset, consider also inner style for multi-style package
        
        NSArray *elements = [vectorStyle componentsSeparatedByString: @":"];
        NSString *fileName = elements[0];
        NSString *styleName = elements[1];
        
        NSString* styleAssetName = [fileName stringByAppendingString: @".zip"];
        NSString* folder = @"";//@"assets/";
        
        styleAssetName = [folder stringByAppendingString:styleAssetName];
        
        NTBinaryData *vectorTileStyleSetData = [NTAssetUtils loadAsset:styleAssetName];
        NTZippedAssetPackage* assetPackage = [[NTZippedAssetPackage alloc] initWithZipData:vectorTileStyleSetData];
        
        vectorTileStyleSet = [[NTCompiledStyleSet alloc] initWithAssetPackage:assetPackage styleName:styleName];
        
    } else {
        
        // Others are single style packages
        
        NSString* styleAssetName = [vectorStyle stringByAppendingString: @".zip"];
        NTBinaryData *vectorTileStyleSetData = [NTAssetUtils loadAsset:styleAssetName];
        NTZippedAssetPackage* assetPackage = [[NTZippedAssetPackage alloc] initWithZipData:vectorTileStyleSetData];
        
        vectorTileStyleSet = [[NTCompiledStyleSet alloc] initWithAssetPackage:assetPackage];
    }
    
    // Create vector tile decoder using the styleset and update style parameters
    self.vectorTileDecoder = [[NTMBVectorTileDecoder alloc] initWithCompiledStyleSet:vectorTileStyleSet];
    [self.vectorTileDecoder setStyleParameter:@"lang" value:self.vectorStyleLanguage];
    
    if (styleBuildings3D) { // only OSM Bright style supports this currently
        [self.vectorTileDecoder setStyleParameter:@"buildings3d" value:@"1"];
    }
    
    [self.vectorTileDecoder setStyleParameter:@"markers3d" value:@"1"];
    [self.vectorTileDecoder setStyleParameter:@"texts3d" value:@"1"];
    [self.vectorTileDecoder setStyleParameter:@"shields3d" value:@"1"];
    
    
    // special parameters for elevation contour style
    [self.vectorTileDecoder setStyleParameter:@"contour_stroke" value:@"rgba(217, 166, 140, 0.53)"];
    [self.vectorTileDecoder setStyleParameter:@"contour_width" value:@"0.8"];
    
    // Create tile data source
    self.vectorTileDataSource = [self createTileDataSource];
    
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
    NTTileDataSource* vectorTileDataSource;
    if ([self.vectorStyleName isEqualToString:@"mapzen"] || [self.vectorStyleName isEqualToString:@"positron"]) {
        vectorTileDataSource = [[NTCartoOnlineTileDataSource alloc] initWithSource:@"mapzen.osm"];
    } else {
        vectorTileDataSource = [[NTCartoOnlineTileDataSource alloc] initWithSource:@"nutiteq.osm"];
    }
    
    // We don't use vectorTileDataSource directly (this would be also option),
    // but via caching to cache data locally non-persistently
    NTTileDataSource* cacheDataSource = [[NTMemoryCacheTileDataSource alloc] initWithDataSource:vectorTileDataSource];
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
    self.vectorStyleName = @"nutibright-v3:default";
    self.vectorStyleLanguage = @"";
    [self updateBaseLayer];
    
    // Create menu
    [self createMenu];
}

@end

@implementation DropDownMenuController

- (id)initWithStyle:(UITableViewStyle)style controller:(VectorMapBaseController*)sampleController
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
        
        UITableViewCell* cell = [VPPDropDown tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
    
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
