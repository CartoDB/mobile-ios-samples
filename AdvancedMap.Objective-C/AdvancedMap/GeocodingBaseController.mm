//
//  GeocodingBaseController.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 21/08/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "GeocodingBaseController.h"

@implementation GeocodingBaseController

- (NSString *)getApiKey {
    return @"mapzen-e2gmwsC";
}

- (NSString *)getFailMessage
{
    [NSException raise:@"NotImplementedException" format:@"getFailMessage function should be overridden in child class"];
    return @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _geocodingSource = [[NTLocalVectorDataSource alloc]initWithProjection:[self getProjection]];
    _geocodingLayer = [[NTVectorLayer alloc]initWithDataSource:_geocodingSource];
    [[self.mapView getLayers]add:_geocodingLayer];
}

- (void)showResult:(NTGeocodingResult *)result title:(NSString *)title description:(NSString *)description goToPosition: (BOOL)goToPosition {
    
    [_geocodingSource clear];
    
    NTAnimationStyleBuilder *animationBuilder = [[NTAnimationStyleBuilder alloc]init];
    [animationBuilder setRelativeSpeed:2.0f];
    [animationBuilder setFadeAnimationType:NT_ANIMATION_TYPE_SMOOTHSTEP];
    
    NTBalloonPopupStyleBuilder *builder = [[NTBalloonPopupStyleBuilder alloc]init];
    [builder setCornerRadius:5];
    [builder setAnimationStyle:[animationBuilder buildStyle]];
    // Make sure this label is shown on top of all other labels
    [builder setPlacementPriority:10];
    
    NTFeatureCollection *collection = [result getFeatureCollection];
    int count = [collection getFeatureCount];
    
    NTColor *color = [[NTColor alloc]initWithR:0 g:100 b:200 a:150];
    
    NTMapPos *position;
    NTGeometry *geometry;
    
    for (int i = 0; i < count; i++) {
        geometry = [[collection getFeature:i] getGeometry];
        
        NTPointStyleBuilder* pointStyleBuilder = [[NTPointStyleBuilder alloc] init];
        [pointStyleBuilder setColor: color];
        
        NTLineStyleBuilder* lineStyleBuilder = [[NTLineStyleBuilder alloc] init];
        [lineStyleBuilder setColor: color];
        
        NTPolygonStyleBuilder* polygonStyleBuilder = [[NTPolygonStyleBuilder alloc] init];
        [polygonStyleBuilder setColor: color];
        
        if ([geometry isKindOfClass:[NTPointGeometry class]]) {
            [_geocodingSource add: [[NTPoint alloc] initWithGeometry:(NTPointGeometry*)geometry style:[pointStyleBuilder buildStyle]]];
        }
        if ([geometry isKindOfClass:[NTLineGeometry class]]) {
            [_geocodingSource add: [[NTLine alloc] initWithGeometry:(NTLineGeometry*)geometry style:[lineStyleBuilder buildStyle]]];
        }
        if ([geometry isKindOfClass:[NTPolygonGeometry class]]) {
            [_geocodingSource add: [[NTPolygon alloc] initWithGeometry:(NTPolygonGeometry*)geometry style:[polygonStyleBuilder buildStyle]]];
        }
        if ([geometry isKindOfClass:[NTMultiGeometry class]]) {
            NTGeometryCollectionStyleBuilder* geomCollectionStyleBuilder = [[NTGeometryCollectionStyleBuilder alloc] init];
            [geomCollectionStyleBuilder setPointStyle:[pointStyleBuilder buildStyle]];
            [geomCollectionStyleBuilder setLineStyle:[lineStyleBuilder buildStyle]];
            [geomCollectionStyleBuilder setPolygonStyle:[polygonStyleBuilder buildStyle]];
            [_geocodingSource add: [[NTGeometryCollection alloc] initWithGeometry:(NTMultiGeometry*)geometry style:[geomCollectionStyleBuilder buildStyle]]];
        }
        position = [geometry getCenterPos];
    }
    
    if (goToPosition) {
        [self.mapView setFocusPos:position durationSeconds:1.0f];
        [self.mapView setZoom:17.0f durationSeconds:1.0f];
    }
    
    NTBalloonPopup *popup = [[NTBalloonPopup alloc]initWithPos:position style:[builder buildStyle] title:title desc:description];
    [_geocodingSource add:popup];
}

@end








