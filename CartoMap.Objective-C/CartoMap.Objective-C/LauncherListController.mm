
#import "LauncherListController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define IsHeader(sample) [[sample objectForKey:@"controller"] rangeOfString:@"Header"].location != NSNotFound

@interface LauncherListController ()
@end

@interface MapListCell : UITableViewCell

@property UIView *topBorder;
@property UILabel *title;
@property UILabel *details;

@property BOOL isHeader;

-(void) update:(NSDictionary *)sample;

@end

@implementation LauncherListController

-(NSArray*) samples
{
    return @[
             /* CARTO.js API */
             @{ @"name": @"CARTO.js API", @"controller": @"Header" },
             @{
                 @"name": @"Countries Vis",
                 @"description": @"Vis displaying countries in different colors using UTFGrid",
                 @"controller": @"CountriesVisController"
                 },
             @{
                 @"name": @"Dots vis",
                 @"description": @"Vis showing dots on the map using UTFGrid",
                 @"controller": @"DotsVisController"
                 },
             @{
                 @"name": @"Fonts Vis",
                 @"description": @"Vis displaying text on the map using UTFGrid",
                 @"controller": @"FontsVisController"
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
                 @"description": @"CARTO data as vector tiles from a named map using Vector listener",
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
                 @"name": @"Torque Map",
                 @"description": @"Shopper movemenet in a mall throughout the day",
                 @"controller": @"TorqueController"
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
    MapListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[MapListCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:identifier];
    }
    
    NSDictionary* sample = [[self samples] objectAtIndex:indexPath.row];
    [cell update:sample];
    
    cell.frame = CGRectMake(0, 0, 320, 70);
    return cell;
}

@end

/*
 * List Cell
 */

@implementation MapListCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    self.topBorder = [[UIView alloc] init];
    [self.topBorder setBackgroundColor: RGB(50, 50, 50)];
    [self addSubview:self.topBorder];
    
    self.title = [[UILabel alloc] init];
    [self.title setFont:[UIFont boldSystemFontOfSize:16]];
    self.title.textAlignment = NSTextAlignmentJustified;
    [self addSubview:self.title];
    
    self.details = [[UILabel alloc] init];
    self.details.numberOfLines = 0;
    [self.details setLineBreakMode:NSLineBreakByWordWrapping];
    [self.details setTextColor:[UIColor darkGrayColor]];
    [self.details setFont:[UIFont systemFontOfSize:12]];
    
    [self addSubview:self.details];
    
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.topBorder setFrame:CGRectMake(0, 0, self.frame.size.width, 3)];
    
    float padding = 10;
    
    float width = self.frame.size.width - 2 * padding;
    float height = self.frame.size.height / 3;
    
    if (self.isHeader) {
        [self.title setFrame:CGRectMake(padding, 0, width, self.frame.size.height)];
    } else {
        [self.title setFrame:CGRectMake(padding, padding, width, height)];
    }
    
    [self.details setFrame:CGRectMake(padding, height + padding, width, self.frame.size.height / 2)];
}

-(void) update:(NSDictionary *)sample
{
    self.isHeader = IsHeader(sample);
    
    self.title.text = [sample objectForKey:@"name"];
    self.details.text = [sample objectForKey:@"description"];
    
    if (self.isHeader) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:RGB(240, 240, 240)];
        [self setAccessibilityIdentifier:@"MapListHeader"];
        [self.topBorder setHidden:false];
    } else {
        [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [self setBackgroundColor:RGB(255, 255, 255)];
        [self setAccessibilityIdentifier:@"MapListCell"];
        [self.topBorder setHidden:true];
    }
    
}

@end


