#import "LauncherListController.h"

@interface LauncherListController ()
@end

@implementation LauncherListController

-(NSArray*) samples
{
    return @[
             @{ @"name": @"Pin Sample", @"controller": @"PinSampleController" },
             @{ @"name": @"2D OverlaysSample", @"controller": @"Overlays2DSampleController" },
             @{ @"name": @"Map Listener Sample", @"controller": @"MapListenerSampleController" },
             @{ @"name": @"3D Overlays Sample", @"controller": @"Overlays3DSampleController" },
             @{ @"name": @"Offline Vector Map Sample", @"controller": @"OfflineVectorMapSampleController" },
             @{ @"name": @"Aerial Map Sample", @"controller": @"AerialMapSampleController" },
             @{ @"name": @"Hillshade Topo Map Sample", @"controller": @"HillshadeSampleController" },
             @{ @"name": @"Custom Raster Data Source Sample", @"controller": @"CustomRasterDataSourceSampleController" },
             @{ @"name": @"Ground Overlay Sample", @"controller": @"GroundOverlaySampleController" },
             @{ @"name": @"Custom Popup Sample", @"controller": @"CustomPopupSampleController" },
             @{ @"name": @"Package Manager Sample", @"controller": @"PackageManagerController" },
             @{ @"name": @"Clustered Random points", @"controller": @"ClusteredRandomPointsController" },
             @{ @"name": @"Clustered GeoJSON points", @"controller": @"ClusteredGeoJsonController" },
             @{ @"name": @"Offline Routing", @"controller": @"OfflineRoutingController" },
             ];
}

- (void)loadView
{
    // Create custom back button for navigation bar
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    // Create table view of samples
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    
    self.view = tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Samples";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    // Launch selected sample, use basic reflection to convert class name to class instance
    NSDictionary* sample = [[self samples] objectAtIndex:indexPath.row];
    UIViewController* subViewController = [[NSClassFromString([sample objectForKey:@"controller"]) alloc] init];
    [subViewController setTitle: [sample objectForKey:@"name"]];
    [self.navigationController pushViewController: subViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self samples] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"sampleId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellIdentifier];
    }
    NSDictionary* sample = [[self samples] objectAtIndex:indexPath.row];
    cell.textLabel.text = [sample objectForKey:@"name"];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
