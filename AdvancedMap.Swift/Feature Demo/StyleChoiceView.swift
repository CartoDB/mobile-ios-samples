//
//  StyleChoiceView.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class StyleChoiceView : MapBaseView {
    
    var popup: SlideInPopup!
    
    var infoButton: PopupButton!
    var languageButton: PopupButton!
    var baseMapButton: PopupButton!
    
    var infoContent: InformationPopupContent!
    var languageContent: LanguagePopupContent!
    var baseMapContent: StylePopupContent!
    
    convenience init() {
        
        self.init(frame: CGRect.zero)
        
        currentLayer = addBaseLayer()
        
        popup = SlideInPopup()
        
        infoButton = PopupButton(imageUrl: "icon_info.png")
        languageButton = PopupButton(imageUrl: "icon_language.png")
        baseMapButton = PopupButton(imageUrl: "icon_basemap.png")
        
        addButton(button: infoButton)
        addButton(button: languageButton)
        addButton(button: baseMapButton)
        
        addSubview(popup)
        sendSubview(toBack: popup)
        
        infoContent = InformationPopupContent()
        languageContent = LanguagePopupContent()
        baseMapContent = StylePopupContent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        popup.frame = bounds
    }
    
    func addRecognizers() {
        
        var recognizer = UITapGestureRecognizer(target: self, action: #selector(self.infoButtonTapped(_:)))
        infoButton.addGestureRecognizer(recognizer)
        
        recognizer = UITapGestureRecognizer(target: self, action: #selector(self.languageButtonTapped(_:)))
        languageButton.addGestureRecognizer(recognizer)
        
        recognizer = UITapGestureRecognizer(target: self, action: #selector(self.mapButtonTapped(_:)))
        baseMapButton.addGestureRecognizer(recognizer)
    }
    
    func removeRecognizers() {
        infoButton.gestureRecognizers?.forEach(infoButton.removeGestureRecognizer)
        languageButton.gestureRecognizers?.forEach(languageButton.removeGestureRecognizer)
        baseMapButton.gestureRecognizers?.forEach(baseMapButton.removeGestureRecognizer)
    }
    
    func infoButtonTapped(_ sender: UITapGestureRecognizer) {
        popup.setContent(content: infoContent)
        popup.popup.header.setText(text: "INFORMATION")
        popup.show()
    }
    
    func languageButtonTapped(_ sender: UITapGestureRecognizer) {
        popup.setContent(content: languageContent)
        popup.popup.header.setText(text: "SELECT A LANGUAGE")
        popup.show()
    }
    
    func mapButtonTapped(_ sender: UITapGestureRecognizer) {
        popup.setContent(content: baseMapContent)
        popup.popup.header.setText(text: "SELECT A BASEMAP")
        popup.show()
    }
    
    func updateMapLanguage(language: String) {
        
        if (currentLayer == nil) {
            return
        }
        
        currentLanguage = language
        
        let decoder = (currentLayer as? NTVectorTileLayer)?.getTileDecoder() as? NTMBVectorTileDecoder
        decoder?.setStyleParameter("lang", value: currentLanguage)
    }
    
    var currentLanguage: String = ""
    var currentSource: String = "nutiteq.osm"
    var currentLayer: NTTileLayer!
    
    func updateBaseLayer(selection: String, source: String) {
        
        if (source == StylePopupContent.NutiteqSource) {
            
            if (selection == StylePopupContent.Bright) {
                currentLayer = NTCartoOnlineVectorTileLayer(style: .CARTO_BASEMAP_STYLE_DEFAULT)
            } else if (selection == StylePopupContent.Gray) {
                currentLayer = NTCartoOnlineVectorTileLayer(style: .CARTO_BASEMAP_STYLE_GRAY)
            } else if (selection == StylePopupContent.Dark) {
                currentLayer = NTCartoOnlineVectorTileLayer(style: .CARTO_BASEMAP_STYLE_DARK)
            }
            
        } else if (source == StylePopupContent.MapzenSource) {
            
            let asset = NTAssetUtils.loadAsset("styles_mapzen.zip")
            let package = NTZippedAssetPackage(zip: asset)
            
            var name = ""
            
            if (selection == StylePopupContent.Bright) {
                name = "style"
            } else if (selection == StylePopupContent.Positron) {
                name = "positron"
            } else if (selection == StylePopupContent.DarkMatter) {
                name = "positron_dark"
            }
            
            let styleSet = NTCompiledStyleSet(assetPackage: package, styleName: name)
            
            let datasource = NTCartoOnlineTileDataSource(source: source)
            let decoder = NTMBVectorTileDecoder(compiledStyleSet: styleSet)
            
            currentLayer = NTVectorTileLayer(dataSource: datasource, decoder: decoder)
            
        } else if (source == StylePopupContent.CartoSource) {
            
            // We know that the value of raster will be Positron or Darkmatter,
            // as Nutiteq and Mapzen use vector tiles
            var url = ""
            
            if (selection == StylePopupContent.Positron) {
                url = StylePopupContent.PositronUrl
            } else {
                url = StylePopupContent.DarkMatterUrl
            }
            
            let datasource = NTHTTPTileDataSource(minZoom: 1, maxZoom: 19, baseURL: url)
            currentLayer = NTRasterTileLayer(dataSource: datasource)
        }
        
        map.getLayers().clear()
        map.getLayers().add(currentLayer)
        
        updateMapLanguage(language: currentLanguage)
    }
}






















