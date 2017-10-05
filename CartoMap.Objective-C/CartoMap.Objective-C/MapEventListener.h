//
//  MapEventListener.h
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 05/10/2017.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import <CartoMobileSDK/CartoMobileSDK.h>

@interface MapEventListener : NTMapEventListener

@property NTLocalVectorDataSource *source;

@end
