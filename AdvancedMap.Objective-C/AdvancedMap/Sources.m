//
//  Sources.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 03/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "Sources.h"

@implementation Sources

NSString *const CARTO_VECTOR_SOURCE = @"carto.streets";
NSString *const MAPZEN_SOURCE = @"mapzen.osm";
NSString *const CARTO_RASTER_SOURCE = @"carto.osm";

NSString *const OFFLINE_ROUTING_SOURCE = @"nutiteq.osm.car";
NSString *const ONLINE_ROUTING_SOURCE = @"nutiteq.osm.car";

NSString *const ROUTING_TAG = @"routing:";

NSString *const GEOCODING_TAG = @"geocoding:";
NSString *const OFFLINE_GEOCODING_SOURCE = @"carto.streets";

NSString *const MAPBOX_API_KEY = @"pk.eyJ1IjoiY2FydG8tYml6LW9wcyIsImEiOiJjamRwcTM4bWcxczFuMzNwMDVqNHVjazd5In0.JG4cW0I1jcLxPdKrYQCTNA";

@end
