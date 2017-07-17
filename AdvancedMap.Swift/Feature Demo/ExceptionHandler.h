//
//  ExceptionHandler.h
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_INLINE NSException * _Nullable tryBlock(void(^_Nonnull tryBlock)(void)) {
    
    @try {
        tryBlock();
    } @catch (NSException *exception) {
        return exception;
    }
    
    return nil;
}
