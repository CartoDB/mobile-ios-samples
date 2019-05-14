//
//  CountryDownloadController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit
import CartoMobileSDK

class OfflineMapController : BasePackageDownloadController {
    
    var mapPackageListener: MapPackageListener!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        contentView = OfflineMapView()
        view = contentView
        
        let folder = Utils.createDirectory(name: "countrypackages")
        contentView.manager = NTCartoPackageManager(source: Routing.MAP_SOURCE, dataFolder: folder)
        
        // Online mode by default
        
        setOnlineMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
    }
    
    override func downloadComplete(sender: PackageListener, id: String) {
        contentView.downloadComplete(id: id)
        goOffline()
    }
    
    override func setOnlineMode() {
        super.setOnlineMode()
        contentView.setOnlineMode()
    }
    
    override func setOfflineMode() {
        super.setOfflineMode()
        contentView.setOfflineMode()
    }
    
}







