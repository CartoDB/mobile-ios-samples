//
//  PackageTableViewCell.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "PackageTableViewCell.h"


/*
 * Special UITableView cell class for displaying packages.
 */
@implementation PackageTableViewCell

- (IBAction)buttonTapped:(id)sender {
    if (self.customActionBlock) {
        self.customActionBlock();
    }
}

@end

