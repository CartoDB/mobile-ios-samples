//
//  Samples.m
//  CartoMap.Objective-C
//
//  Created by Aare Undo on 28/09/2017.
//  Copyright © 2017 Aare Undo. All rights reserved.
//

#import "Samples.h"

@implementation Sample

@end

@implementation Samples

+ (NSMutableArray *)getList {
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    Sample *sample = [[Sample alloc] init];
    
    sample = [[Sample alloc] init];
    sample.title = @"Raster Tile";
    sample.subtitle = @"PostGIS Raster in CARTO as anonymous map";
    sample.controller = @"AnonymousRasterTableController";
    sample.imageUrl = @"icon_sample_raster_tile.png";
    [list addObject:sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"Vector Tile";
    sample.subtitle = @"CARTO Maps API with vector tiles";
    sample.controller = @"AnonymousVectorTableController";
    sample.imageUrl = @"icon_sample_vector_tile.png";
    [list addObject:sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"Named Map";
    sample.subtitle = @"Indoor map as vector tiles from CARTO";
    sample.controller = @"NamedMapController";
    sample.imageUrl = @"icon_sample_named_map.png";
    [list addObject:sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"SQL Service";
    sample.subtitle = @"Cities from CARTO Engine SQL API";
    sample.controller = @"SQLServiceController";
    sample.imageUrl = @"icon_sample_sql_service.png";
    [list addObject:sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"Torque Map";
    sample.subtitle = @"Indoor positions as animated Torque view";
    sample.controller = @"TorqueController";
    sample.imageUrl = @"icon_sample_torque.png";
    [list addObject:sample];
    
    return list;
}

@end
