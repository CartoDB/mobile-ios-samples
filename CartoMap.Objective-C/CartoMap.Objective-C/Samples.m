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
    sample.title = @"Countries Vis";
    sample.subtitle = @"Vis displaying countries in different colors using UTFGrid";
    sample.controller = @"CountriesVisController";
    sample.imageUrl = @"icon_sample_countries_vis.png";
    [list addObject:sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"Dots Vis";
    sample.subtitle = @"Vis showing dots on the map using UTFGrid";
    sample.controller = @"DotsVisController";
    sample.imageUrl = @"icon_sample_dots_vis.png";
    [list addObject:sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"Raster Tile";
    sample.subtitle = @"Using Carto PostGIS anonymous raster data";
    sample.controller = @"AnonymousRasterTableController";
    sample.imageUrl = @"icon_sample_raster_tile.png";
    [list addObject:sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"Vector Tile";
    sample.subtitle = @"Usage of Carto Maps API with anonymous vector tiles";
    sample.controller = @"AnonymousVectorTableController";
    sample.imageUrl = @"icon_sample_vector_tile.png";
    [list addObject:sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"Named Map";
    sample.subtitle = @"CARTO data as vector tiles from a named map using Vector listener";
    sample.controller = @"NamedMapController";
    sample.imageUrl = @"icon_sample_named_map.png";
    [list addObject:sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"SQL Service";
    sample.subtitle = @"Displays cities on the map via SQL query";
    sample.controller = @"SQLServiceController";
    sample.imageUrl = @"icon_sample_sql_service.png";
    [list addObject:sample];
    
    sample = [[Sample alloc] init];
    sample.title = @"Torque Map";
    sample.subtitle = @"Shopper movemenet in a mall throughout the da";
    sample.controller = @"TorqueController";
    sample.imageUrl = @"icon_sample_torque.png";
    [list addObject:sample];
    
    return list;
}

@end
