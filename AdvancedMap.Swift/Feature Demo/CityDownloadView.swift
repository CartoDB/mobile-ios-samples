//
//  CityDownloadView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class CityDownloadView : DownloadBaseView {
    
    var cityButton: PopupButton!
    
    var cityContent: CityPopupContent!
    
    var onlineLayer: NTCartoOnlineVectorTileLayer!
    var offlineLayer: NTCartoOfflineVectorTileLayer!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        onlineLayer = addBaseLayer()
        
        initialize()
        initializeDownloadContent()
        
        infoContent.setText(headerText: Texts.cityDownloadInfoHeader, contentText: Texts.cityDownloadInfoContainer)
        
        cityButton = PopupButton(imageUrl: "icon_global.png")
        addButton(button: cityButton)
        
        cityContent = CityPopupContent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func addRecognizers() {
        
        super.addRecognizers()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.cityButtonTapped(_:)))
        cityButton.addGestureRecognizer(recognizer)
    }
    
    override func removeRecognizers() {
        
        super.removeRecognizers()
        
        cityButton.gestureRecognizers?.forEach(cityButton.removeGestureRecognizer)
    }
    
    func cityButtonTapped(_ sender: UITapGestureRecognizer) {
        
        if (cityButton.isEnabled) {
            popup.setContent(content: cityContent)
            popup.popup.header.setText(text: "SELECT A CITY")
            popup.show()
        }
    }
    
    func setOnlineMode() {
        map.getLayers().remove(offlineLayer)
        map.getLayers().insert(0, layer: onlineLayer)
    }
    
    func setOfflineMode(manager: NTCartoPackageManager) {
        map.getLayers().remove(onlineLayer)
        offlineLayer = NTCartoOfflineVectorTileLayer(packageManager: manager, style: .CARTO_BASEMAP_STYLE_DEFAULT)
        map.getLayers().insert(0, layer: offlineLayer)
    }
}
