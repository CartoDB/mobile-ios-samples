//
//  BaseMapsView.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 22/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "BaseMapsView.h"

@implementation BaseMapsView

- (id) init {
    self = [super init];
    
    self.styleButton = [[PopupButton alloc] initWithImageUrl:@"icon_basemap.png"];
    [self addButton:self.styleButton];
    
    self.languageButton = [[PopupButton alloc] initWithImageUrl:@"icon_language.png"];
    [self addButton:self.languageButton];

    self.mapOptionsButton = [[PopupButton alloc] initWithImageUrl:@"icon_switches.png"];
    [self addButton:self.mapOptionsButton];

    self.styleContent = [[StylePopupContent alloc] init];
    self.languageContent = [[LanguagePopupContent alloc] init];
    self.mapOptionsContent = [[MapOptionsPopupContent alloc] init];
    
    self.currentLayer = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_VOYAGER];
    [[self.mapView getLayers] add:self.currentLayer];

    self.currentLanguage = @"en";
    self.buildings3D = NO;
    self.texts3D = YES;
    return self;
}

- (void)setLanguageContent {
    [self setContent:self.languageContent];
}

- (void)setBasemapContent {
    [self setContent:self.styleContent];
}

- (void)setMapOptionsContent {
    [self setContent:self.mapOptionsContent];
}

- (void)updateBaseLayer:(NSString *)selection source:(NSString *)source {
    self.currentOSM = source;
    self.currentSelection = selection;

    if ([source isEqualToString: StylePopupContent.CartoVectorSource]) {
        
        if ([self.currentSelection isEqualToString:StylePopupContent.Voyager]) {
            self.currentLayer  = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_VOYAGER];
        } else if ([self.currentSelection isEqualToString:StylePopupContent.Positron]) {
            self.currentLayer  = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_POSITRON];
        } else if ([self.currentSelection isEqualToString:StylePopupContent.DarkMatter]) {
            self.currentLayer  = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_DARKMATTER];
        }
    } else if ([source isEqualToString: StylePopupContent.CartoRasterSource]) {

        NSString *url = @"";
        
        if ([self.currentSelection isEqualToString:StylePopupContent.Positron]) {
            url = StylePopupContent.PositronUrl;
        } else if ([self.currentSelection isEqualToString:StylePopupContent.Voyager]) {
            url = StylePopupContent.VoyagerUrl;
        } else {
            url = StylePopupContent.DarkMatterUrl;
        }
        
        NTTileDataSource *source = [[NTHTTPTileDataSource alloc] initWithMinZoom:1 maxZoom:19 baseURL:url];
        self.currentLayer = [[NTRasterTileLayer alloc] initWithDataSource:source];
    }
    
    [[self.mapView getLayers] clear];
    [[self.mapView getLayers] add:self.currentLayer];
    
    [self updateLanguage:self.currentLanguage];
    [self updateMapOption:@"buildings3d" value:self.buildings3D];
    [self updateMapOption:@"texts3d" value:self.texts3D];
    
    [self initializeVectorTileListener];
}


- (void)initializeVectorTileListener {
    if (self.vectorLayer == nil) {
        NTProjection *projection = [[self.mapView getOptions] getBaseProjection];
        NTLocalVectorDataSource *source = [[NTLocalVectorDataSource alloc] initWithProjection:projection];
        self.vectorLayer = [[NTVectorLayer alloc] initWithDataSource:source];
    } else {
        [[self.mapView getLayers] remove:self.vectorLayer];
    }
    
    [[self.mapView getLayers] add:self.vectorLayer];
    
    [self updateListener];
}

- (void)updateListener {
    NTLayer *layer = [[self.mapView getLayers] get:0];
    
    if ([layer isKindOfClass:NTVectorTileLayer.class]) {
        if (self.listener == nil) {
            self.listener = [[VectorTileListener alloc] init];
        }
        
        self.listener.vectorLayer = self.vectorLayer;
        [((NTVectorTileLayer *)layer) setVectorTileEventListener:self.listener];
    }
}

- (void)updateLanguage:(NSString *)code {
    self.currentLanguage = code;

    if (self.currentLayer == nil) {
        return;
    }
    
    if (![self.currentLayer isKindOfClass:NTVectorTileLayer.class]) {
        // Raster tile language chance is not supported
        return;
    }
    
    NTVectorTileLayer *layer = (NTVectorTileLayer *)self.currentLayer;
    NTMBVectorTileDecoder *decoder = (NTMBVectorTileDecoder *)[layer getTileDecoder];
    
    [decoder setStyleParameter:@"lang" value:code];
}

- (void)updateMapOption:(NSString *)option value:(BOOL)value {
    if ([option isEqualToString:@"globe"]) {
        [[self.mapView getOptions] setRenderProjectionMode:(value ? NT_RENDER_PROJECTION_MODE_SPHERICAL : NT_RENDER_PROJECTION_MODE_PLANAR)];
        return;
    }

    if (self.currentLayer == nil) {
        return;
    }
    
    if (![self.currentLayer isKindOfClass:NTVectorTileLayer.class]) {
        // Raster tile language chance is not supported
        return;
    }
    
    NTVectorTileLayer *layer = (NTVectorTileLayer *)self.currentLayer;
    NTMBVectorTileDecoder *decoder = (NTMBVectorTileDecoder *)[layer getTileDecoder];

    if ([option isEqualToString:@"buildings3d"]) {
        self.buildings3D = value;
        [decoder setStyleParameter:@"buildings" value:(value ? @"2" : @"1")];
    }
    if ([option isEqualToString:@"texts3d"]) {
        self.texts3D = value;
        [decoder setStyleParameter:@"texts3d" value:(value ? @"1" : @"0")];
    }
}

@end
