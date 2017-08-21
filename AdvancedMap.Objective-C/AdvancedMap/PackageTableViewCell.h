//
//  PackageTableViewCell.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 * Special UITableView cell class for displaying packages.
 */
@interface PackageTableViewCell : UITableViewCell

- (IBAction)buttonTapped:(id)sender;

@property (nonatomic, copy) void (^customActionBlock)();

@end

