//
//  MainView.m
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 28/09/2017.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import "MainView.h"

@implementation MainView

- (id)init {
    
    self = [super init];
    
    self.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1];
    
    self.views = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:singleFingerTap];
    
    return self;
}

- (void)tapped:(UITapGestureRecognizer * _Nonnull)sender {
    
    CGPoint location = [sender locationInView:self];
    
    for (int i = 0; i < self.views.count; i++) {
        UIView *view = [self.views objectAtIndex:i];
        
        if (CGRectContainsPoint([view frame], location)) {
            [self.galleryDelegate galleryItemClickWithItem:(GalleryRow *)view];
        }
    }
}

- (void)layoutSubviews {
    
    CGFloat itemsInRow = 2;
    
    if ([self frame].size.width > [self frame].size.width) {
        itemsInRow = 3;
        
        if ([self frame].size.width > 1000) {
            itemsInRow = 4;
        }
    } else if ([self frame].size.width > 700) {
        itemsInRow = 3;
    }
    
    CGFloat padding = 5;
    
    CGFloat x = padding;
    CGFloat y = padding;
    CGFloat w = ([self frame].size.width - (itemsInRow + 1) * padding) / itemsInRow;
    CGFloat h = w;
    
    for (int i = 0; i < self.views.count; i++) {
        
        UIView *view = [self.views objectAtIndex:i];
        [view setFrame:CGRectMake(x, y, w, h)];
        
        if (x == ((w * (itemsInRow - 1)) + padding * itemsInRow)) {
            y += h + padding;
            x = padding;
        } else {
            x += w + padding;
        }
        
        if (i == self.views.count - 1) {
            CGFloat height = y + h + padding;
            [self setContentSize:CGSizeMake([self frame].size.width, height)];
        }
    }
}

- (void)addRowsWithRows:(NSArray<Sample *> * _Nonnull)rows {
    
    [self.views removeAllObjects];
    
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        
        if ([view isKindOfClass:GalleryRow.class]) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < rows.count; i++) {
        
        GalleryRow *row = [[GalleryRow alloc] init];
        [self addSubview:row];
        [self.views addObject:row];
        
        [row update: [rows objectAtIndex:i]];
    }
}

@end





