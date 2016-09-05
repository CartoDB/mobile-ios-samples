//
//  MyUTFGridEventListener.m
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 02/09/16.
//  Copyright © 2016 Aare Undo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyUTFGridEventListener.h"

@implementation MyUTFGridEventListener

- (BOOL)onUTFGridClicked:(NTUTFGridClickInfo *)utfGridClickInfo
{
    NTLocalVectorDataSource* dataSource;
    
    if (self.vectorLayer != nil) {
        dataSource = (NTLocalVectorDataSource*)[self.vectorLayer getDataSource];
    } else {
        dataSource = self.source;
    }
    
    [dataSource clear];
    
    NTBalloonPopup* clickPopup = [[NTBalloonPopup alloc] init];
    NTBalloonPopupStyleBuilder* styleBuilder = [[NTBalloonPopupStyleBuilder alloc] init];
    // Make sure this label is shown on top all other labels
    [styleBuilder setPlacementPriority:10];
    
    // Check the type of the click
    NTVariant* elementInfo = [utfGridClickInfo getElementInfo];
    NSString* clickMsg = [elementInfo description];
    clickPopup = [[NTBalloonPopup alloc] initWithPos:[utfGridClickInfo getClickPos]
                                               style:[styleBuilder buildStyle]
                                               title:@"Clicked"
                                                desc:clickMsg];
    [dataSource add:clickPopup];
    
    return YES;
}

@end