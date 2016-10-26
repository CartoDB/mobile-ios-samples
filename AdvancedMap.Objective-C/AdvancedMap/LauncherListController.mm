#import "LauncherListController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define IsHeader(sample) [[sample objectForKey:@"controller"] rangeOfString:@"Header"].location != NSNotFound

@interface LauncherListController ()
@end

@implementation LauncherListController

-(NSArray*) samples
{
    return @[
             /* Base maps */
             @{ @"name": @"Base maps", @"controller": @"Header" },
             @{ @"name": @"Base maps",
                @"description": @"Choice of different Base Maps",
                @"controller": @"BaseMapsController"
                },
             
             /* Overlay Data sources */
             @{ @"name": @"Overlay data sources", @"controller": @"Header" },
             @{ @"name": @"Custom Raster Data Source Sample",
                @"description": @"Creating and using custom raster tile data source",
                @"controller": @"CustomRasterDataSourceController"
                },
             @{ @"name": @"Ground Overlay Sample",
                @"description": @"Adding ground-level raster overlay",
                @"controller": @"GroundOverlayController"
                },
             @{ @"name": @"WMS Map",
                @"description": @"WMS service raster on top of the vector base map",
                @"controller": @"WMSMapController"
                },
             
             /* Vector Objects */
             @{ @"name": @"Vector objects", @"controller": @"Header" },
             @{ @"name": @"2D OverlaysSample",
                @"description": @"2D objects: lines, points, polygon with hole, texts and pop-ups",
                @"controller": @"Overlays2DController"
                },
             @{ @"name": @"3D Overlays Sample",
                @"description": @"3D vector elements: 3D polygon, 3D model (NML) and 3D city (NMLDB)",
                @"controller": @"Overlays3DController"
                },
             
             /* Offline maps */
             @{ @"name": @"Offline maps", @"controller": @"Header" },
             @{ @"name": @"Bundled MBTiles Sample",
                @"description": @"Bundle MBTiles file for offline base map",
                @"controller": @"BundledMBTilesController"
                },
             @{ @"name": @"Package Manager",
                @"description": @"Download offline map packages with OSM",
                @"controller": @"PackageManagerController"
                },
             
             /* GIS */
             @{ @"name": @"GIS", @"controller": @"Header" },
             @{ @"name": @"Basic editable overlay",
                @"description": @"CShows usage of an editable vector layer",
                @"controller": @"BasicEditableOverlayController"
                },
             
            /* Other */
             @{ @"name": @"Other", @"controller": @"Header" },
             @{ @"name": @"Screencapture",
                @"description": @"Captures rendered MapView as a Bitmap",
                @"controller": @"CaptureController"
                },
             @{ @"name": @"Clustered Random points",
                @"description": @"Creates 1000 randomly positioned markers on the map",
                @"controller": @"ClusteredRandomPointsController"
                },
             @{ @"name": @"Clustered GeoJSON points",
                @"description": @"Reading data from GeoJSON and adding clustered Markers to map",
                @"controller": @"ClusteredGeoJsonController"
                },
             @{ @"name": @"Custom Popup Sample",
                @"description": @"Creating and using custom popups",
                @"controller": @"CustomPopupController"
                },
             @{ @"name": @"Offline Routing",
                @"description": @"Offline routing with OpenStreetMap data packages",
                @"controller": @"OfflineRoutingController"
                }
            ];
}

- (void)loadView
{
    // Create custom back button for navigation bar
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    // Create table view of samples
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    
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
    NSDictionary* sample = [[self samples] objectAtIndex:indexPath.row];
    
    if (IsHeader(sample)) {
        // Return if clicked on header, they're not supposed to be interactive
        return;
    }
    
    NSString* controllerString = [sample objectForKey:@"controller"];
    
    // Launch selected sample, use basic reflection to convert class name to class instance
    UIViewController* controller = [[NSClassFromString(controllerString) alloc] init];
    [controller setTitle: [sample objectForKey:@"name"]];
    [self.navigationController pushViewController: controller animated:YES];
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
    NSDictionary* sample = [[self samples] objectAtIndex:indexPath.row];
    
    if (IsHeader(sample)) {
        return 40;
    }
    
    return 70;
}

static NSString* identifier = @"sampleId";

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:identifier];
        cell.detailTextLabel.numberOfLines = 0;
        [cell.detailTextLabel setTextColor:[UIColor darkGrayColor]];
    }
    
    NSDictionary* sample = [[self samples] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [sample objectForKey:@"name"];
    cell.detailTextLabel.text = [sample objectForKey:@"description"];

    if (IsHeader(sample)) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:RGB(240, 240, 240)];
        [cell setAccessibilityIdentifier:@"MapListHeader"];
    } else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell setBackgroundColor:RGB(255, 255, 255)];
        [cell setAccessibilityIdentifier:@"MapListCell"];
    }
    
    return cell;
}

@end












