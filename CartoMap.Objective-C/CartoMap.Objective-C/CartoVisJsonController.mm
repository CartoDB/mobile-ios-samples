
#import "MapBaseController.h"
#import "VPPDropDown.h"
#import "VPPDropDownDelegate.h"

#import "MyCartoVisBuilder.h"
#import "MyVectorTileListener.h"

/*
 * A sample demonstrating how to use high-level Carto VisJSON API.
 * A list of different visjson URLs can be selected from the menu.
 * CartoVisLoader class is used to load and configure all corresponding layers.
 * Items on overlay layers are clickable, this is implemented using custom UTFGridEventListener.
 */
@interface CartoVisJsonController : MapBaseController

@property NSString* visJSONURL;
@property NTAssetPackage* fontsAssetPackage;
@property NSTimer* timer;
@property NTVectorLayer* vectorLayer;

@end

/*
 * Dropdown controller library
 */
@interface VisDropDownMenuController : UITableViewController <VPPDropDownDelegate, UIActionSheetDelegate>

- (id)initWithStyle:(UITableViewStyle)style controller:(CartoVisJsonController*)sampleController;

@property VPPDropDown* dropDownVis;
@property(weak) CartoVisJsonController* sampleController;

@end

/*
 * Implementation
 */
@implementation CartoVisJsonController

-(NSDictionary*)visJSONURLs
{
    return @{
             @"circle": @"http://documentation.cartodb.com/api/v2/viz/836e37ca-085a-11e4-8834-0edbca4b5057/viz.json",
             @"countries": @"http://documentation.cartodb.com/api/v2/viz/2b13c956-e7c1-11e2-806b-5404a6a683d5/viz.json",
             @"cities": @"https://cartomobile-team.carto.com/u/nutiteq/api/v2/viz/f1407ed4-84b8-11e6-96bc-0ee66e2c9693/viz.json",
             @"geonames clusters":@"https://cartomobile-team.carto.com/u/nutiteq/api/v2/viz/d1bda058-5562-401a-beba-7df8891d5f06/viz.json",
             @"micell indoors": @"https://cartomobile-team.cartodb.com/u/nutiteq/api/v2/viz/69f3eebe-33b6-11e6-8634-0e5db1731f59/viz.json"
             };
}

- (void)updateVis
{
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self.mapView getLayers] clear];
        
        // Create overlay layer for popups
        NTProjection* proj = [[self.mapView getOptions] getBaseProjection];
        NTLocalVectorDataSource* dataSource = [[NTLocalVectorDataSource alloc] initWithProjection:proj];
        NTVectorLayer* vectorLayer = [[NTVectorLayer alloc] initWithDataSource:dataSource];
        
        // Create VIS loader
        NTCartoVisLoader* loader = [[NTCartoVisLoader alloc] init];
        [loader setVectorTileAssetPackage:self.fontsAssetPackage];
        [loader setDefaultVectorLayerMode:YES];
        
        MyCartoVisBuilder* visBuilder = [[MyCartoVisBuilder alloc] init];
        visBuilder.vectorLayer = vectorLayer;
        visBuilder.mapView = self.mapView;
        visBuilder.torqueLayer = nil;
        
        [loader loadVis:visBuilder visURL:self.visJSONURL];
        
        // Kill old timer, create new timer if Torque layer is used
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        if (visBuilder.torqueLayer) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(onTick:) userInfo:visBuilder.torqueLayer repeats:YES];
            });
        }
        
        // Add the created popup overlay layer on top of all visJSON layers
        [[self.mapView getLayers] add:vectorLayer];
        
    });
}

- (void)onTick:(NSTimer*)timer
{
    // NTTorqueTileDecoder* tmp = [[NTTorqueTileDecoder alloc] initWithStyleSet:nil];
    
    NTTorqueTileLayer* torqueLayer = (NTTorqueTileLayer*)timer.userInfo;
    NTTorqueTileDecoder* torqueDecoder = (NTTorqueTileDecoder*)[torqueLayer getTileDecoder];
    
    // Loop with wrapping
    int frameNr = [torqueLayer getFrameNr];
    frameNr = (frameNr + 1) % [torqueDecoder getFrameCount];
    [torqueLayer setFrameNr:frameNr];
}

- (void)showMenu
{
    VisDropDownMenuController* menuController = [[VisDropDownMenuController alloc] initWithStyle:UITableViewStylePlain controller:self];
    [self.navigationController pushViewController:menuController animated:YES];
}

- (void)createMenu
{
    UIImage* menuImage = [UIImage imageNamed:@"menu.png"];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target: self action: @selector(showMenu)];
    [self.navigationItem setRightBarButtonItem: menuButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NTLog setShowDebug:true];
    [NTLog setShowInfo:true];
    
    // Load fonts package
    NTBinaryData* fontsData = [NTAssetUtils loadAsset:@"carto-fonts.zip"];
    self.fontsAssetPackage = [[NTZippedAssetPackage alloc] initWithZipData:fontsData];
    
    // Set default vis
    self.visJSONURL = [self.visJSONURLs objectForKey: @"cities"];
    [self updateVis];
    
    // Create menu
    [self createMenu];
    
}

@end


@implementation VisDropDownMenuController

- (id)initWithStyle:(UITableViewStyle)style controller:(CartoVisJsonController*)sampleController
{
    self = [super initWithStyle:style];
    if (self) {
        self.sampleController = sampleController;
        
        // Custom initialization
        NSInteger selectedVis = [[[sampleController visJSONURLs] allValues] indexOfObject:sampleController.visJSONURL];
        _dropDownVis = [[VPPDropDown alloc] initSelectionWithTitle:@"Sample"
                                                         tableView:self.tableView
                                                         indexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                          delegate:self
                                                     selectedIndex:(int)selectedVis
                                                     elementTitles:[[sampleController visJSONURLs] allKeys]];
        [_dropDownVis setExpanded:YES];
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
    rows += 1;
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

- (void)dropDown:(VPPDropDown *)dropDown elementSelected:(VPPDropDownElement *)element atGlobalIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [[self tableView] cellForRowAtIndexPath:indexPath];
    
    if (dropDown == _dropDownVis) {
        self.sampleController.visJSONURL = [[self.sampleController visJSONURLs] objectForKey:cell.textLabel.text];
        [self.sampleController updateVis];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
