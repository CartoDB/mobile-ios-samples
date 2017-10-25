//
//  PackageDownloadBaseController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 18/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "PackageDownloadBaseController.h"

@implementation PackageDownloadBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listener = [[PackageDownloadListener alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.listener.delegate = self;
    
    [self.contentView.manager setPackageManagerListener:self.listener];
    [self.contentView.manager start];
    [self.contentView.manager startPackageListDownload];
    
    self.contentView.packageContent.table.delegate = self;
    self.contentView.popup.popup.header.backButton.delegate = self;
    
    [self.contentView addRecognizer:self view:self.contentView.downloadButton action:@selector(downloadButtonTap:)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.listener.delegate = nil;

    [self.contentView.manager setPackageManagerListener: nil];
    [self.contentView.manager stop:false];
    
    self.contentView.packageContent.table.delegate = nil;
    self.contentView.popup.popup.header.backButton.delegate = nil;
    
    [self.contentView removeRecognizerFrom: self.contentView.downloadButton];
}

- (void)clickWithSender:(UIView *)sender {
    [self.contentView onBackButtonClick];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Package *package = self.contentView.packageContent.packages[indexPath.row];
    [self.contentView onPackageClick: package];
}

- (void)downloadButtonTap:(UITapGestureRecognizer *)recognizer {
    
    if (![self.contentView isPackageContent]) {
        [self.contentView setPackageContent];
    }
    
    [self.contentView.popup show];
}

- (void)listDownloadComplete {
    [self.contentView listDownloadComplete];
}

- (void)listDownloadFailed {
    
}

- (void)statusChanged:(NSString *)identifier status:(NTPackageStatus *)status {
    [self.contentView statusChanged:identifier status:status];
}

- (void)downloadComplete:(NSString *)identifier {
    [self.contentView downloadComplete:identifier];
}

- (void)downloadFailed:(NTPackageErrorType *)error {
    [self.contentView downloadFailed:error];
}

- (NSString *)createFolder:(NSString *)name {
    // Create folder for package manager. Package manager needs persistent writable folder.
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask,YES);
    NSString* appSupportDir = [paths objectAtIndex: 0];
    NSString* packagesDir = [appSupportDir stringByAppendingString:name];
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:packagesDir withIntermediateDirectories:YES attributes:nil error:&error];
    
    return packagesDir;
}

@end




