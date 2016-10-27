
#import "LauncherListController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define IsHeader(sample) [[sample objectForKey:@"controller"] rangeOfString:@"Header"].location != NSNotFound

@interface LauncherListController ()
@end

@implementation LauncherListController

-(NSArray*) samples
{
    return @[
             /* CARTO.js API */
             @{ @"name": @"CARTO.js API", @"controller": @"Header" },
             @{
                 @"name": @"Countries Vis",
                 @"description": @"Vis displaying countries in different colors",
                 @"controller": @"CountriesVisController"
                 },
             @{
                 @"name": @"Dots vis",
                 @"description": @"Vis showing dots on the map",
                 @"controller": @"DotsVisController"
                 },
             @{
                 @"name": @"Fonts Vis",
                 @"description": @"Vis displaying text on the map",
                 @"controller": @"FontsVisController"
                 },
             
             /* Import API */
             @{ @"name": @"Import APII", @"controller": @"Header" },
             @{
                 @"name": @"Tile Packager",
                 @"description": @"Packaging tiles (?) //TODO",
                 @"controller": @"TilePackagerController"
                 },
             
             /* Maps API */
             @{ @"name": @"Maps API", @"controller": @"Header" },
             @{
                 @"name": @"Anonymous Raster Tile",
                 @"description": @"Using Carto PostGIS Raster data",
                 @"controller": @"AnonymousRasterTableController"
                 },
             @{
                 @"name": @"Anonymous Vector Tile",
                 @"description": @"Usage of Carto Maps API with vector tiles",
                 @"controller": @"AnonymousVectorTableController"
                 },
             @{
                 @"name": @"Named Map",
                 @"description": @"CARTO data as vector tiles from a named map",
                 @"controller": @"NamedMapController"
                 },
             
             /* SQL API */
             @{ @"name": @"SQL API", @"controller": @"Header" },
             @{
                 @"name": @"SQL Service",
                 @"description": @"Displays cities on the map via SQL query",
                 @"controller": @"SQLServiceController"
                 },
             
             /* Torque API */
             @{ @"name": @"Torque API", @"controller": @"Header" },
             @{
                 @"name": @"Carto Torque Map",
                 @"description": @"Torque tiles of WWII ship movement",
                 @"controller": @"TorqueShipController"
                 },
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
    self.navigationItem.title = @"Carto Map Samples";
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


