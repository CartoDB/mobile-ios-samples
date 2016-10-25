#import "LauncherListController.h"

@interface LauncherListController ()
@end

@implementation LauncherListController

-(NSArray*) samples
{
    return @[
             @{ @"name": @"2D OverlaysSample",
                @"description": @"2D objects: lines, points, polygon with hole, texts and pop-ups",
                @"controller": @"Overlays2DSampleController"
             },
             @{ @"name": @"3D Overlays Sample",
                @"description": @"3D vector elements: 3D polygon, 3D model (NML) and 3D city (NMLDB)",
                @"controller": @"Overlays3DSampleController"
             },
             @{ @"name": @"Offline Vector Map Sample",
                @"description": @"Bundle MBTiles file for offline base map",
                @"controller": @"OfflineVectorMapSampleController"
             },
             @{ @"name": @"Offline Routing",
                @"description": @"Offline routing with OpenStreetMap data packages",
                @"controller": @"OfflineRoutingController"
             },
             @{ @"name": @"Package Manager Sample",
                @"description": @"Download offline map packages with OSM",
                @"controller": @"PackageManagerController"
             },
             @{ @"name": @"Ground Overlay Sample",
                @"description": @"Adding ground-level raster overlay",
                @"controller": @"GroundOverlaySampleController"
             },
             @{ @"name": @"Custom Raster Data Source Sample",
                @"description": @"creating and using custom raster tile data source",
                @"controller": @"CustomRasterDataSourceController"
             },
             @{ @"name": @"Custom Popup Sample",
                @"description": @"creating and using custom popups",
                @"controller": @"CustomPopupSampleController"
             },
             @{ @"name": @"Clustered Random points",
                @"description": @"Creates 1000 randomly positioned markers on the map",
                @"controller": @"ClusteredRandomPointsController"
             },
             @{ @"name": @"Clustered GeoJSON points",
                @"description": @"Reading data from GeoJSON and adding clustered Markers to map",
                @"controller": @"ClusteredGeoJsonController"
             }
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
    self.navigationItem.title = @"Advanced Map Samples";
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"sampleId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setAccessibilityIdentifier:@"MapListCell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary* sample = [[self samples] objectAtIndex:indexPath.row];
    cell.textLabel.text = [sample objectForKey:@"name"];
    cell.detailTextLabel.text = [sample objectForKey:@"description"];
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
}

@end
