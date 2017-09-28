//
//  MainViewController.h
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 28/09/2017.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CartoMobileSDK/CartoMobileSDK.h>
#import "MainView.h"
#import "Samples.h"

@interface MainViewController : UIViewController <GalleryDelegate>

@property MainView *contentView;

@end
