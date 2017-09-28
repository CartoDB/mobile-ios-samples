//
//  GalleryRow.h
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 28/09/2017.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Samples.h"

@interface GalleryRow : UIView

@property UIImageView *imageView;
@property UILabel *titleView;
@property UILabel *descriptionView;

@property Sample *sample;

- (void)update:(Sample *)sample;

@end
