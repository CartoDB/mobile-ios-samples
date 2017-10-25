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
    
    self.styleContent = [[StylePopupContent alloc] init];
    self.languageContent = [[LanguagePopupContent alloc] init];
    
    self.currentLayer = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_VOYAGER];
    [[self.mapView getLayers] add:self.currentLayer];
    return self;
}

- (void)setLanguageContent {
    [self setContent:self.languageContent];
}

- (void)setBasemapContent {
    [self setContent:self.styleContent];
}

- (void)updateBaseLayer:(NSString *)selection :(NSString *)source
{
    self.currentOSM = source;
    self.currentSelection = selection;

    NSString* language = nil;
    if ([self.currentLayer isKindOfClass:NTVectorTileLayer.class]) {
        NTVectorTileLayer *layer = (NTVectorTileLayer *)self.currentLayer;
        NTMBVectorTileDecoder *decoder = (NTMBVectorTileDecoder *)[layer getTileDecoder];
        
        language = [decoder getStyleParameter:@"lang"];
    }

    if ([source isEqualToString: StylePopupContent.CartoVectorSource]) {
        
        if ([self.currentSelection isEqualToString:StylePopupContent.Voyager]) {
            self.currentLayer  = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_VOYAGER];
        } else if ([self.currentSelection isEqualToString:StylePopupContent.Positron]) {
            self.currentLayer  = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_POSITRON];
        } else if ([self.currentSelection isEqualToString:StylePopupContent.DarkMatter]) {
            self.currentLayer  = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:NT_CARTO_BASEMAP_STYLE_DARKMATTER];
        }
    } else if ([source isEqualToString: StylePopupContent.MapzenSource]) {
        
        NSString *fileName = @"styles_mapzen.zip";
        NSString *styleName = @"";
        
        if ([selection isEqualToString: StylePopupContent.Bright]) {
            styleName = @"style";
        } else if ([selection isEqualToString: StylePopupContent.Positron]) {
            styleName = @"positron";
        } else if ([selection isEqualToString: StylePopupContent.DarkMatter]) {
            styleName = @"positron_dark";
        }
            
        NTBinaryData *styleAsset = [NTAssetUtils loadAsset:fileName];
        NTZippedAssetPackage *package = [[NTZippedAssetPackage alloc] initWithZipData:styleAsset];
        NTCompiledStyleSet *set = [[NTCompiledStyleSet alloc] initWithAssetPackage:package styleName:styleName];
            
        NTCartoOnlineTileDataSource *source = [[NTCartoOnlineTileDataSource alloc] initWithSource:self.currentOSM];
        NTMBVectorTileDecoder *decoder = [[NTMBVectorTileDecoder alloc] initWithCompiledStyleSet:set];
            
        self.currentLayer = [[NTVectorTileLayer alloc] initWithDataSource:source decoder:decoder];
        
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
    
    if (language) {
        [self updateLanguage:language];
    }
    
    [[self.mapView getLayers] clear];
    [[self.mapView getLayers] add:self.currentLayer];
    
    [self initializeVectorTileListener];
}


- (void)initializeVectorTileListener
{
    if (self.vectorLayer == nil) {
        NTProjection *projection = [[self.mapView getOptions]getBaseProjection];
        NTLocalVectorDataSource *source = [[NTLocalVectorDataSource alloc]initWithProjection:projection];
        self.vectorLayer = [[NTVectorLayer alloc]initWithDataSource:source];
    } else {
        [[self.mapView getLayers] remove:self.vectorLayer];
    }
    
    [[self.mapView getLayers] add:self.vectorLayer];
    
    [self updateListener];
}

- (void)updateListener
{
    NTLayer *layer = [[self.mapView getLayers] get:0];
    
    if ([layer isKindOfClass:NTVectorTileLayer.class]) {
        if (self.listener == nil) {
            self.listener = [[VectorTileListener alloc]init];
        }
        
        self.listener.vectorLayer = self.vectorLayer;
        [((NTVectorTileLayer *)layer) setVectorTileEventListener:self.listener];
    }
}

- (void)updateLanguage:(NSString *)code
{
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

@end




