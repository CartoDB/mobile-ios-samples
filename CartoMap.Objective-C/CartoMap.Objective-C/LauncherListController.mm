
#import "LauncherListController.h"

@interface LauncherListController ()
@end

@implementation LauncherListController

-(NSArray*) samples
{
    return @[
             @{ @"name": @"Carto VisJson Sample",
                @"description": @"Using high-level Carto VisJson API",
                @"controller": @"CartoVisJsonController"
                },
             @{ @"name": @"",
                @"description": @"",
                @"controller": @""
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



