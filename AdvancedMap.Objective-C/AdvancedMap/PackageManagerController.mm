
/*
 * A sample demonstrating how to use offline package manager of the Carto Mobile SDK.
 *
 * The sample downloads the latest package list from Carto online service,
 * displays this list and allows user to manage offline packages (download, update, delete them).
 *
 * Note that the sample does not include NTMapViewController, but using download packages
 * is actually very similar to using other tile sources - SDK contains PackageManagerTileDataSource
 * that will automatically display all imported or downloaded packages.
 */

#import "PackageManagerController.h"
#import "PackageManagerListener.h"

static NSString* _language = @"en"; // the language for package names

@implementation PackageManagerController

- (id)init
{
    // Create folder for package manager. Package manager needs persistent writable folder.
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask,YES);
    NSString* appSupportDir = [paths objectAtIndex: 0];
    NSString* packagesDir = [appSupportDir stringByAppendingString:@"regionpackages"];
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:packagesDir withIntermediateDirectories:YES attributes:nil error:&error];
    
    // Create package manager and package manager listener
    _packageManager = [[NTCartoPackageManager alloc] initWithSource:CARTO_VECTOR_SOURCE dataFolder:packagesDir];
    _packageManagerListener = [[PackageManagerListener alloc] init];
    
    // Register this controller with listener to receive notifications about events
    [(PackageManagerListener *)_packageManagerListener addPackageManagerController:self];
    
    // Attach package manager listener
    [_packageManager setPackageManagerListener:_packageManagerListener];
    
    _currentFolder = @"";
    
    [self createMenu];
    
    return [super init];
}

- (id)initWithParent:(PackageManagerController*)controller folder:(NSString*)folder
{
    _packageManager = [controller packageManager];
    _packageManagerListener = [controller packageManagerListener];
    
    // Register this controller with listener to receive notifications about events
    [(PackageManagerListener *)_packageManagerListener addPackageManagerController:self];
    
    _currentFolder = folder;
    
    [self createMenu];
    
    return [super init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Check if the view is closing
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [(PackageManagerListener *)_packageManagerListener removePackageManagerController:self];
        
        if ([_currentFolder length] == 0) {
            // Stop package manager
            [_packageManager stop:YES];
            
            // Detach listener
            [_packageManager setPackageManagerListener:nil];
        }
        
        // Reset references
        _packageManagerListener = nil;

        _packageManager = nil;
    }
    
    [super viewWillDisappear:animated];
}

- (void)loadView
{
    // Create table view of packages
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.view = tableView;
    
    // Start package manager
    if (![_packageManager start]) {
        [PackageManagerController displayToastWithMessage:@"Could not start package manager"];
    }
    
    // Download package list from the server. This is an asychronous operation and listener
    // when the list is received (or the operation failed)
    [_packageManager startPackageListDownload];
    
    [self updatePackages];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Package* pkg = nil;
    @try {
        pkg = [[self getPackages] objectAtIndex:indexPath.row];
    }
    @catch (NSException* exception) {
        return;
    }
    
    // If actual package was selected, use associated cell callback (block).
    // Otherwise open subcontroller with a new subfolder.
    if (pkg.packageInfo) {
        PackageTableViewCell* cell = (PackageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell buttonTapped:self];
    } else {
        NSString* newFolder = [[_currentFolder stringByAppendingString:[pkg packageName]] stringByAppendingString:@"/"];
        UIViewController* subViewController = [[PackageManagerController alloc] initWithParent:self folder:newFolder];
        [subViewController setTitle: [pkg packageName]];
        [self.navigationController pushViewController: subViewController animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self getPackages] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"packageId";
    
    // Get package info
    Package* pkg = nil;
    @try {
        pkg = [[self getPackages] objectAtIndex:indexPath.row];
    }
    @catch (NSException* exception) {
        return nil;
    }
    
    // Try to reuse existing cell for the package
    PackageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PackageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // Set cell name
    cell.textLabel.text = [pkg packageName];
    
    // Display details and action button depending whether this is an actual package or simply folder
    if (pkg.packageInfo) {
        NSString* status;
        if ([pkg.packageInfo getSize] < 1024 * 1024) {
            status = [NSString stringWithFormat: @"version %d available (<1MB)", [pkg.packageInfo getVersion]];
        } else {
            status = [NSString stringWithFormat: @"version %d  available (%lluMB)", [pkg.packageInfo getVersion], [pkg.packageInfo getSize] / 1024 / 1024];
        }
        
        NSString* action = @"DL";
        
        if (pkg.packageStatus) {
            if ([pkg.packageStatus getCurrentAction] == NT_PACKAGE_ACTION_READY) {
                status = @"ready";
                action = @"RM";
                cell.customActionBlock = ^ {
                    [_packageManager startPackageRemove:[pkg.packageInfo getPackageId]];
                    
                };
            } else if ([pkg.packageStatus getCurrentAction] == NT_PACKAGE_ACTION_WAITING) {
                status = @"queued";
                action = @"C";
                cell.customActionBlock = ^ {
                    [_packageManager cancelPackageTasks:[pkg.packageInfo getPackageId]];
                };
            } else {
                if ([pkg.packageStatus getCurrentAction] == NT_PACKAGE_ACTION_COPYING) {
                    status = @"copying";
                } else if ([pkg.packageStatus getCurrentAction] == NT_PACKAGE_ACTION_DOWNLOADING) {
                    status = @"downloading";
                } else if ([pkg.packageStatus getCurrentAction] == NT_PACKAGE_ACTION_REMOVING) {
                    status = @"removing";
                }
                status = [NSString stringWithFormat: @"%@ %d%%", status, (int) [pkg.packageStatus getProgress]];
                if ([pkg.packageStatus isPaused]) {
                    status = [NSString stringWithFormat: @"%@ (paused)", status];
                    action = @"R";
                    cell.customActionBlock = ^{
                        [_packageManager setPackagePriority:[pkg.packageInfo getPackageId] priority:0];
                    };
                } else {
                    action = @"P";
                    cell.customActionBlock = ^{
                        [_packageManager setPackagePriority:[pkg.packageInfo getPackageId] priority:-1];
                    };
                }
            }
        } else {
            cell.customActionBlock = ^{
                [_packageManager startPackageDownload:pkg.packageId];
            };
        }
        
        cell.detailTextLabel.text = status;
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [label setText:action];
        cell.accessoryView = label;
    } else {
        cell.detailTextLabel.text = @"";
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (NSArray*)getPackages
{
    @synchronized(self) {
        
        if (_currentPackages != nil) {
            return _currentPackages;
        }
        
        NTPackageInfoVector* packageInfoVector = [_packageManager getServerPackages];
        NSMutableArray* packages = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [packageInfoVector size]; i++) {
            
            NTPackageInfo* packageInfo = [packageInfoVector get:i];
            NTStringVector* packageNames = [packageInfo getNames:_language];
            
            for (int j = 0; j < [packageNames size]; j++) {
                NSString* packageName = [packageNames get:j];
                
                if ([packageName length] < [_currentFolder length]) {
                    continue;
                }
                if ([[packageName substringToIndex:[_currentFolder length]] compare:_currentFolder] != NSOrderedSame) {
                    continue;
                }

                packageName = [packageName substringFromIndex:[_currentFolder length]];
                NSRange range = [packageName rangeOfString:@"/"];
                Package* pkg = nil;
                
                if (range.location == NSNotFound) {
                    
                    // This is an actual package
                    NTPackageStatus* packageStatus = [_packageManager getLocalPackageStatus:[packageInfo getPackageId] version:-1];
                    pkg = [[Package alloc] initWithPackageName:packageName packageInfo:packageInfo packageStatus:packageStatus];
                    
                } else {
                    
                    // This is a package group
                    packageName = [packageName substringToIndex:range.location];

                    NSMutableArray *existingPackages = [[NSMutableArray alloc]init];
                    
                    for (int k = 0; k < packages.count; k++) {
                        Package *package = [packages objectAtIndex:k];
                        if ([package.packageName isEqualToString: packageName]) {
                            [existingPackages addObject:package];
                        }
                    }

                    if (existingPackages.count == 0) {

                        // If there are none, add a package group if we don't have an existing list item
                        pkg = [[Package alloc] initWithPackageName:packageName packageInfo:nil packageStatus:nil];
                        
                    } else if (existingPackages.count == 1 && ((Package *)[existingPackages objectAtIndex:0]).packageInfo != nil) {

                        // Sometimes we need to add two labels with the same name.
                        // One a downloadable package and the other pointing to a list of said country's counties,
                        // such as with Spain, Germany, France, Great Britain
                        
                        // If there is one existing package and its info isn't null,
                        // we will add a "parent" package containing subpackages (or package group)
                        
                        pkg = [[Package alloc] initWithPackageName:packageName packageInfo:nil packageStatus:nil];
                        
                    } else {
                        // Shouldn't be added, as both cases are accounted for
                        continue;
                    }
                }

                [packages addObject:pkg];
            }
        }
        
        _currentPackages = packages;
        return _currentPackages;
    }
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)updatePackages
{
    @synchronized(self) {
        _currentPackages = nil; // cached package list has become invalid
    }
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)updatePackage:(NSString*)packageId
{
    // Note: the following code works, but it would be better to do more granular update of the package
    @synchronized(self) {
        _currentPackages = nil; // TODO: find correct package and update its status
    }
    // TODO: find row corresponding to the given package and update only single package
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

+ (void)displayToastWithMessage:(NSString*)toastMessage
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
        UILabel *toastView = [[UILabel alloc] init];
        toastView.text = toastMessage;
        toastView.textColor = [UIColor blackColor];
        toastView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        toastView.textAlignment = NSTextAlignmentCenter;
        toastView.frame = CGRectMake(0.0, 0.0, keyWindow.frame.size.width/2.0, 100.0);
        toastView.layer.cornerRadius = 10;
        toastView.layer.masksToBounds = YES;
        toastView.center = keyWindow.center;
        
        [keyWindow addSubview:toastView];
        
        [UIView animateWithDuration:3.0f delay:0.0f options:UIViewAnimationOptionCurveEaseOut
                         animations: ^{
                             toastView.alpha = 0.0f;
                         }
                         completion: ^(BOOL finished) {
                             [toastView removeFromSuperview];
                         }
         ];
    }];
}


- (void)createMenu
{
    UIImage* menuImage = [UIImage imageNamed:@"852-map-toolbar.png"];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target: self action: @selector(showMap)];
    [self.navigationItem setRightBarButtonItem: menuButton];
}

- (void)showMap
{
    PackageMapController* mapController = [[PackageMapController alloc] init];
    mapController.packageManager = _packageManager;
    [self.navigationController pushViewController:mapController animated:YES];
}

@end


