//
//  BaseGeocodingController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 03/08/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class BaseGeocodingController : BasePackageDownloadController {
    
    override func downloadComplete(sender: PackageListener, id: String) {
        contentView.downloadComplete(id: id)
        
        DispatchQueue.main.async {
            
            AppDelegate.printTimeWithMessage(message: "Download finished at")
            let package = self.contentView.manager?.getLocalPackage(id)
            
            if (package == nil) {
                return;
            }
            
            var name = package?.getName()
            let id = package?.getPackageId()
            
            if (id?.contains(Package.BBOX_IDENTIFIER))! {
                name = Cities.findNameById(id: (package?.getPackageId())!)
            }
            
            let text = "DOWNLOADED (" + name! + String(describing: (package?.getSizeInMB())!) + "MB)"
            self.contentView.progressLabel.complete(message: text)
            
            if (self.contentView is GeocodingView) {
                (self.contentView as! GeocodingView).showSearchBar()
            }
            
            self.goOffline()
        }
        
    }

    static let API_KEY = "mapzen-e2gmwsC"
    static let MAPBOX_KEY = "pk.eyJ1IjoiY2FydG8tYml6LW9wcyIsImEiOiJjamRwcTM4bWcxczFuMzNwMDVqNHVjazd5In0.JG4cW0I1jcLxPdKrYQCTNA"
}




