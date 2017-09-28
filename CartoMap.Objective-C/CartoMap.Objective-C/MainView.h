//
//  MainView.h
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 28/09/2017.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Samples.h"
#import "GalleryRow.h"

@protocol GalleryDelegate
- (void)galleryItemClickWithItem:(GalleryRow * _Nonnull)item;
@end

@interface MainView : UIScrollView

@property (nonatomic, strong) id <GalleryDelegate> _Nullable galleryDelegate;

@property NSMutableArray * _Nullable views;

- (void)tapped:(UITapGestureRecognizer * _Nonnull)sender;
- (void)layoutSubviews;
- (void)addRowsWithRows:(NSArray<Sample *> * _Nonnull)rows;

@end
