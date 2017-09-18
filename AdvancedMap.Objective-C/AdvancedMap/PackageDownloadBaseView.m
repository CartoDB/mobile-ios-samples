//
//  PackageDownloadBaseView.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 18/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "PackageDownloadBaseView.h"

@implementation PackageDownloadBaseView

- (id) init {
    self = [super init];
    
    self.downloadButton = [[PopupButton alloc] initWithImageUrl:@"icon_global.png"];
    [self addButton:_downloadButton];
    
    self.packageContent = [[PackagePopupContent alloc] init];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = [self frame].size.width;
    CGFloat h = [self bottomLabelHeight];
    CGFloat x = 0;
    CGFloat y = [self frame].size.height - h;
    
    [self.progressLabel setFrame:CGRectMake(x, y, w, h)];
    
}
- (void)setPackageContent {
    [self.popup setContent:self.packageContent];
}

- (BOOL)isPackageContent {
    return self.popup.content == self.packageContent;
}

- (void)listDownloadComplete {
    [self updateList];
}

- (void)statusChanged:(NSString *)identifier status: (NTPackageStatus *)status {
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        Package *download = [self getCurrentDownload];
        
        if (download != nil) {
            
            if ([status getProgress] == 100) {
                [self.progressLabel completeWithMessage:@"Download complete"];
            } else {
                NSString *progress = [NSString stringWithFormat:@"%f", [status getProgress]];
                NSString *text = [[[[@"Downloading " stringByAppendingString: download.name] stringByAppendingString:@": "] stringByAppendingString:progress] stringByAppendingString:@"%"];
                [self.progressLabel updateWithText:text];
            }
            
            [self.progressLabel updateProgressBarWithProgress:[status getProgress]];
            
            // Need to get it again, as else we'd be changing the status of this variable,
            // not the one in the queue. However, no longer the need to null check
            // I actually have no idea if this is necessary or not.
            // Different languages behave differently when dealing with memory managment
            [self getCurrentDownload].status = status;
        }
        
        [self.packageContent findAndUpdateWithId:identifier status:status];
    });
}

- (void)downloadComplete:(NSString *)identifier {
    [self updateList];
}

- (void)updateList {
    NSArray *packages = [self getPackages];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.packageContent addPackagesWithPackages:packages];
        [self.packageContent.table reloadData];
    });
}

- (NSArray *)getPackages
{
    @synchronized(self) {
        
        NTPackageInfoVector* packageInfoVector = [self.manager getServerPackages];
        NSMutableArray* packages = [[NSMutableArray alloc] init];
        
        if (self.folder == CUSTOM_REGION_FOLDER_NAME) {
            NSArray *custom = [self getCustomRegionPackages];
            [packages addObjectsFromArray:custom];
            return packages;
        }
        
        if (self.folder.length == 0) {
            [packages addObjectsFromArray:[self getCustomRegionPackages]];
        }
        
        for (int i = 0; i < [packageInfoVector size]; i++) {
            
            NTPackageInfo* info = [packageInfoVector get:i];
            NSString* name = [info getName];

            if ([name length] < [self.folder length]) {
                continue;
            }
            if ([[name substringToIndex:[self.folder length]] compare:self.folder] != NSOrderedSame) {
                continue;
            }
            
            name = [name substringFromIndex:[self.folder length]];
            NSRange range = [name rangeOfString:@"/"];
            Package* pkg = nil;
            
            if (range.location == NSNotFound) {
                    
                // This is an actual package
                NTPackageStatus* status = [self.manager getLocalPackageStatus:[info getPackageId] version:-1];
                pkg = [[Package alloc] initWithPackageName:name packageInfo:info packageStatus:status];
            
            } else {
                    
                // This is a package group
                name = [name substringToIndex:range.location];
                
                NSMutableArray *existingPackages = [[NSMutableArray alloc]init];
                    
                for (int k = 0; k < packages.count; k++) {
                    Package *package = [packages objectAtIndex:k];
                    if ([package.name isEqualToString: name]) {
                        [existingPackages addObject:package];
                    }
                }
                
                if (existingPackages.count == 0) {
                        
                    // If there are none, add a package group if we don't have an existing list item
                    pkg = [[Package alloc] initWithPackageName:name packageInfo:nil packageStatus:nil];
                        
                } else if (existingPackages.count == 1 && ((Package *)[existingPackages objectAtIndex:0]).info != nil) {
                        
                    // Sometimes we need to add two labels with the same name.
                    // One a downloadable package and the other pointing to a list of said country's counties,
                    // such as with Spain, Germany, France, Great Britain
                    
                    // If there is one existing package and its info isn't null,
                    // we will add a "parent" package containing subpackages (or package group)
                        
                    pkg = [[Package alloc] initWithPackageName:name packageInfo:nil packageStatus:nil];
                        
                } else {
                    // Shouldn't be added, as both cases are accounted for
                    continue;
                }
                
                [packages addObject:pkg];
            }
        }
        
        return packages;
    }
}

- (NSArray *)getCustomRegionPackages
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    // TODO after we get the list of cities
    return list;
}

- (Package *)getCurrentDownload {
    // TODO after we complete initial build logic
    return [[Package alloc] init];
}

@end





