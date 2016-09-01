#import "MapSampleBaseController.h"
#import "VPPDropDown.h"
#import "VPPDropDownDelegate.h"

/*
 * A sample demonstrating how to use high-level Carto VisJSON API.
 * A list of different visjson URLs can be selected from the menu.
 * CartoVisLoader class is used to load and configure all corresponding layers.
 * Items on overlay layers are clickable, this is implemented using custom UTFGridEventListener.
 */
@interface CartoVisJSONSampleController : MapSampleBaseController

@property NSString* visJSONURL;
@property NTAssetPackage* fontsAssetPackage;
@property NSTimer* timer;

@end

@interface MyCartoVisBuilder : NTCartoVisBuilder

@property NTMapView* mapView;
@property NTVectorLayer* vectorLayer;
@property NTTorqueTileLayer* torqueLayer;

@end

@interface MyUTFGridEventListener : NTUTFGridEventListener

@property NTVectorLayer* vectorLayer;
@property NTVariant* infoWindowTemplate;

@end

@interface VisDropDownMenuController : UITableViewController <VPPDropDownDelegate, UIActionSheetDelegate>

- (id)initWithStyle:(UITableViewStyle)style controller:(CartoVisJSONSampleController*)sampleController;

@property VPPDropDown* dropDownVis;
@property(weak) CartoVisJSONSampleController* sampleController;

@end

@implementation CartoVisJSONSampleController

-(NSDictionary*)visJSONURLs
{
    return @{
             @"circle": @"http://documentation.cartodb.com/api/v2/viz/836e37ca-085a-11e4-8834-0edbca4b5057/viz.json",
             @"countries": @"http://documentation.cartodb.com/api/v2/viz/2b13c956-e7c1-11e2-806b-5404a6a683d5/viz.json",
             @"dots": @"https://documentation.cartodb.com/api/v2/viz/236085de-ea08-11e2-958c-5404a6a683d5/viz.json",
             @"israel":@"https://cartomobile-team.cartodb.com/u/nutiteq/api/v2/viz/8336e3ee-267e-11e6-8410-0e787de82d45/viz.json",
             @"micello": @"https://cartomobile-team.cartodb.com/u/nutiteq/api/v2/viz/69f3eebe-33b6-11e6-8634-0e5db1731f59/viz.json"
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
    
    self.visJSONURL = [self.visJSONURLs objectForKey: @"dots"];
    [self updateVis];
    
    // Create menu
    [self createMenu];
}

@end

@implementation MyUTFGridEventListener

- (BOOL)onUTFGridClicked:(NTUTFGridClickInfo *)utfGridClickInfo
{
    NTLocalVectorDataSource* dataSource = (NTLocalVectorDataSource*)[self.vectorLayer getDataSource];
    [dataSource clear];
    
    NTBalloonPopup* clickPopup = [[NTBalloonPopup alloc] init];
    NTBalloonPopupStyleBuilder* styleBuilder = [[NTBalloonPopupStyleBuilder alloc] init];
    // Make sure this label is shown on top all other labels
    [styleBuilder setPlacementPriority:10];
    
    // Check the type of the click
    NTVariant* elementInfo = [utfGridClickInfo getElementInfo];
    NSString* clickMsg = [elementInfo description];    
    clickPopup = [[NTBalloonPopup alloc] initWithPos:[utfGridClickInfo getClickPos]
                                               style:[styleBuilder buildStyle]
                                               title:@"Clicked"
                                               desc:clickMsg];
    [dataSource add:clickPopup];
    return YES;
}

@end

@implementation MyCartoVisBuilder

-(void)setDescription:(NTVariant *)descriptionInfo
{
    NSLog(@"%@",[descriptionInfo description]);
}

- (void)setCenter:(NTMapPos *)mapPos
{
    [self.mapView setFocusPos:[[[self.mapView getOptions] getBaseProjection] fromWgs84:mapPos] durationSeconds:1.0f];
}

- (void)setZoom:(float)zoom
{
    [self.mapView setZoom:zoom durationSeconds:1.0f];
}

- (void)addLayer:(NTLayer *)layer attributes:(NTVariant *)attributes
{
    // Add the layer to the map view
    [[self.mapView getLayers] add:layer];

    // Check if the layer has info window. In that case will add a custom UTF grid event listener to the layer.
    NTVariant* infoWindow = [attributes getObjectElement:@"infowindow"];
    if ([infoWindow getType] == NT_VARIANT_TYPE_OBJECT) {
        MyUTFGridEventListener* myEventListener = [[MyUTFGridEventListener alloc] init];
        myEventListener.vectorLayer = self.vectorLayer;
        myEventListener.infoWindowTemplate = infoWindow;
        NTTileLayer* tileLayer = (NTTileLayer*)layer;
        [tileLayer setUTFGridEventListener:myEventListener];
    }
    
    // Check if torque layer, if yes, then store it
    if ([layer isKindOfClass:[NTTorqueTileLayer class]]) {
        self.torqueLayer = (NTTorqueTileLayer*)layer;
    }
}

@end

@implementation VisDropDownMenuController

- (id)initWithStyle:(UITableViewStyle)style controller:(CartoVisJSONSampleController*)sampleController
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
