//
//  CountryDownloadView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

class PackageDownloadView : DownloadBaseView {
    
    var countryButton: PopupButton!
    
    var packageContent: PackagePopupContent!
    
    var onlineLayer: NTCartoOnlineVectorTileLayer!
    var offlineLayer: NTCartoOfflineVectorTileLayer!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        onlineLayer = addBaseLayer()
        
        initialize()
        initializeDownloadContent()
        
        infoContent.setText(headerText: Texts.packageDownloadInfoHeader, contentText: Texts.packageDownloadInfoContainer)
        
        countryButton = PopupButton(imageUrl: "icon_global.png")
        addButton(button: countryButton)
        
        packageContent = PackagePopupContent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func addRecognizers() {
        
        super.addRecognizers()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.countryButtonTapped(_:)))
        countryButton.addGestureRecognizer(recognizer)
    }
    
    override func removeRecognizers() {
        
        super.removeRecognizers()
        
        countryButton.gestureRecognizers?.forEach(countryButton.removeGestureRecognizer)
    }
    
    func countryButtonTapped(_ sender: UITapGestureRecognizer) {
        
        if (countryButton.isEnabled) {
            popup.setContent(content: packageContent)
            popup.popup.header.setText(text: "SELECT A PACKAGE")
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
