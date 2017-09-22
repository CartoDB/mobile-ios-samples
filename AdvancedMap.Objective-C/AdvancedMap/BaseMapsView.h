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

@property StylePopupContent *styleContent;
@property LanguagePopupContent *languageContent;

- (void)setLanguageContent;
- (void)setBasemapContent;

- (void)updateBaseLayer:(NSString *)selection :(NSString *)source;

- (void)updateLanguage:(NSString *)code;

@end
