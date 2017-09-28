//
//  GalleryRow.m
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 28/09/2017.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import "GalleryRow.h"

@implementation GalleryRow

- (id)init {
    
    self = [super init];
    
    self.backgroundColor = UIColor.whiteColor;
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1] CGColor];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self addSubview:self.imageView];
    
    self.titleView = [[UILabel alloc] init];
    self.titleView.textColor = [UIColor colorWithRed:14/255.0f green:122/255.0f blue:254/255.0f alpha:1];
    self.titleView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [self addSubview:self.titleView];
    
    self.descriptionView = [[UILabel alloc] init];
    self.descriptionView.textColor = [UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1];
    self.descriptionView.lineBreakMode = NSLineBreakByWordWrapping;
    self.descriptionView.numberOfLines = 0;
    self.descriptionView.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    [self addSubview:self.descriptionView];
    
    return self;
}

- (void)layoutSubviews {
    
    [self.titleView sizeToFit];
    [self.descriptionView sizeToFit];
    
    CGFloat padding = 5.0;
    CGFloat imageHeight = self.frame.size.height / 5 * 3;
    
    CGFloat x = padding;
    CGFloat y = padding;
    CGFloat w = self.frame.size.width - 2 * padding;
    CGFloat h = imageHeight;
    
    self.imageView.frame = CGRectMake(x, y, w, h);
    
    y += h + padding;
    h = self.titleView.frame.size.height;
    
    self.titleView.frame = CGRectMake(x, y, w, h);
    
    y += h + padding;
    h = self.descriptionView.frame.size.height;
    
    self.descriptionView.frame = CGRectMake(x, y, w, h);
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor colorWithRed:100/255 green:100/255 blue:100/255 alpha:1].CGColor;
    self.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.alpha = 0.5f;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.alpha = 1.0f;
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.alpha = 1.0f;
    [super touchesCancelled:touches withEvent:event];
}

- (void)update:(Sample *)sample {
    self.sample = sample;
    
    self.imageView.image = [UIImage imageNamed:sample.imageUrl];
    self.titleView.text = sample.title;
    self.descriptionView.text = sample.subtitle;
}

@end









