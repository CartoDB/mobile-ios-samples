//
//  CityDownloadController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class CityDownloadController : BaseController, UITableViewDelegate, PackageDownloadDelegate, SwitchDelegate {
    
    var contentView: CityDownloadView!
    
    var mapPackageListener: MapPackageListener!
    var mapManager: NTCartoPackageManager!
    
    override func viewDidLoad() {
        
        contentView = CityDownloadView()
        view = contentView
        
        contentView.cityContent.addCities(cities: Cities.list)
        
        let folder = Utils.createDirectory(name: "citypackages")
        mapManager = NTCartoPackageManager(source: Routing.MAP_SOURCE, dataFolder: folder)
        
        // Online mode by default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        contentView.cityContent.table.delegate = self
        
        mapPackageListener = MapPackageListener()
        mapPackageListener.delegate = self
        mapManager.setPackageManagerListener(mapPackageListener)
        mapManager.start()
        
        contentView.onlineSwitch.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        contentView.cityContent.table.delegate = nil
        
        mapManager.stop(true)
        mapPackageListener = nil
        
        contentView.onlineSwitch.delegate = nil
    }
    
    func switchChanged() {
        if (contentView.onlineSwitch.isOn()) {
            contentView.setOnlineMode()
        } else {
            contentView.setOfflineMode(manager: mapManager)
        }
    }
    
    var currentDownload: City!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.popup.hide()
        
        let city = contentView.cityContent.cities[indexPath.row]
        currentDownload = city
        
        let id = city.boundingBox.toString()
        mapManager.startPackageDownload(id)
        
        contentView.progressLabel.show()
    }
    
    func listDownloadComplete() {
        // No implementation
    }
    
    func listDownloadFailed() {
        // No implemenetation
    }
    
    func statusChanged(sender: PackageListener, status: NTPackageStatus) {
        DispatchQueue.main.async {
            let text = "Downloading " + self.currentDownload.name + ": " + String(describing: status.getProgress()) + ""
            self.contentView.progressLabel.update(text: text)
            self.contentView.progressLabel.updateProgressBar(progress: CGFloat(status.getProgress()))
        }
    }
    
    func downloadComplete(sender: PackageListener, id: String) {
        
        let boundingBox = BoundingBox.fromString(projection: contentView.projection, route: id)
        
        contentView.map.setFocus(boundingBox.bounds.getCenter(), durationSeconds: 1)
        contentView.map.setZoom(8, durationSeconds: 1)
    }
    
    func downloadFailed(sender: PackageListener, errorType: NTPackageErrorType) {
        
    }
}






