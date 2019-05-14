//
//  CountryDownloadView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class OfflineMapView : PackageDownloadBaseView {

    convenience init() {
        self.init(frame: CGRect.zero)
        
        initialize()
        initializeDownloadContent()
        initializePackageDownloadContent()
        
        infoContent.setText(headerText: Texts.packageDownloadInfoHeader, contentText: Texts.packageDownloadInfoContainer)
    }

}
