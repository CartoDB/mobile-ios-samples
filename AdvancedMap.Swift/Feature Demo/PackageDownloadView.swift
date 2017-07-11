//
//  CountryDownloadView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

class PackageDownloadView : PackageDownloadBaseView {

    convenience init() {
        self.init(frame: CGRect.zero)
        
        onlineLayer = addBaseLayer()
        
        initialize()
        initializeDownloadContent()
        initializePackageDownloadContent()
        
        infoContent.setText(headerText: Texts.packageDownloadInfoHeader, contentText: Texts.packageDownloadInfoContainer)
    }

}
