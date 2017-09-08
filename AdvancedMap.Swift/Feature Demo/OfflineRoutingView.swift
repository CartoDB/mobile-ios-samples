//
//  OfflineRoutingView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 04/08/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class OfflineRoutingView: PackageDownloadBaseView {
 
    convenience init() {
        self.init(frame: CGRect.zero)
        
        initialize()
        initializeDownloadContent(withSwitch: true)
        initializePackageDownloadContent()
        
        let popupTitle = Texts.offlineRoutingInfoHeader
        let popupDescription = Texts.offlineRoutingInfoContainer
        infoContent.setText(headerText: popupTitle, contentText: popupDescription)
    }
}
