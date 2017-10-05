//
//  MainViewController.m
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 28/09/2017.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"CARTO MAP";
    
    self.contentView = [[MainView alloc] init];
    self.view = self.contentView;
    
    NSMutableArray *list = [Samples getList];
    [self.contentView addRowsWithRows:list];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.contentView.galleryDelegate = self;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.contentView.galleryDelegate = nil;
}

- (void) galleryItemClickWithItem:(GalleryRow *)item {
    
    // Launch selected sample, use basic reflection to convert class name to class instance
    UIViewController* controller = [[NSClassFromString(item.sample.controller) alloc] init];
    [controller setTitle: item.sample.title];
    [[self navigationController] pushViewController:controller animated:true];
}

@end
