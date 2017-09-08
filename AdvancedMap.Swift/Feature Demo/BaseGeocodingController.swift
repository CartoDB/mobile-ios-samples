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
        }
    }

    static let API_KEY = "mapzen-e2gmwsC"
}




