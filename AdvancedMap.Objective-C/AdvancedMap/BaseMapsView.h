//
//  BaseMapsView.h
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 22/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "MapBaseView.h"
#import "VectorTileListener.h"

@interface BaseMapsView : MapBaseView

@property NSString *currentOSM;
@property NSString *currentSelection;
@property NTTileLayer *currentLayer;

@property NTVectorLayer *vectorLayer;
@property VectorTileListener *listener;

@property PopupButton *styleButton;
@property PopupButton *languageButton;
@property PopupButton *mapOptionsButton;

@property StylePopupContent *styleContent;
@property LanguagePopupContent *languageContent;
@property MapOptionsPopupContent *mapOptionsContent;

- (void)setLanguageContent;
- (void)setBasemapContent;
- (void)setMapOptionsContent;

- (void)updateBaseLayer:(NSString *)selection :(NSString *)source;

- (void)updateLanguage:(NSString *)code;

- (void)updateMapOption:(NSString *)option :(BOOL)value;

@end
