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
        
        let folder = Utils.createDirectory(name: "citypackages")
        mapManager = NTCartoPackageManager(source: Routing.MAP_SOURCE, dataFolder: folder)
        
        // Online mode by default
        
        
        for city in Cities.list {
            let id = city.boundingBox.toString()
            let package = mapManager.getLocalPackage(id)

            if (package != nil) {
                city.size = package!.getSizeInMB()
            }
        }
        
        contentView.cityContent.addCities(cities: Cities.list)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        contentView.cityContent.table.delegate = self
        
        mapPackageListener = MapPackageListener()
        mapPackageListener.delegate = self
        mapManager.setPackageManagerListener(mapPackageListener)
        mapManager.start()
        
        contentView.switchButton.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        contentView.cityContent.table.delegate = nil
        
        mapManager.stop(true)
        mapPackageListener = nil
        
        contentView.switchButton.delegate = nil
    }
    
    func switchChanged() {
        if (contentView.switchButton.isOnline()) {
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
        
        if (city.isDownloaded()) {
            let center = city.boundingBox.getCenter()
            let position = contentView.projection.fromLat(center.getY(), lng: center.getX())
            zoomTo(position: position!)
        } else {
            let id = city.boundingBox.toString()
            mapManager.startPackageDownload(id)
        
            contentView.progressLabel.show()
        }
    }
    
    func listDownloadComplete() {
        // No implementation
    }
    
    func listDownloadFailed() {
        // No implemenetation
    }
    
    func statusChanged(sender: PackageListener, status: NTPackageStatus) {
        DispatchQueue.main.async {
            
            let progress = String(describing: Int(exactly: status.getProgress())!)
            let text = "Downloading " + self.currentDownload.name + ": " + progress + "%"
            self.contentView.progressLabel.update(text: text)
            self.contentView.progressLabel.updateProgressBar(progress: CGFloat(status.getProgress()))
        }
    }
    
    func downloadComplete(sender: PackageListener, id: String) {
        
        let boundingBox = BoundingBox.fromString(projection: contentView.projection, route: id)
        
        let package = mapManager.getLocalPackage(boundingBox.toString())
        
        if (package != nil) {
            contentView.cityContent.update(id: boundingBox.toString(), size: package!.getSizeInMB())
        }
        
        zoomTo(position: boundingBox.bounds.getCenter())
        
        DispatchQueue.main.async {
            let name = String(describing:self.currentDownload.name!)
            let size = String(describing:package!.getSizeInMB())
            let text = "Downloaded " + name + " (" + size + " MB)"
            self.contentView.progressLabel.complete(message: text)
        }
    }
    
    func zoomTo(position: NTMapPos) {
        contentView.map.setFocus(position, durationSeconds: 1)
        contentView.map.setZoom(8, durationSeconds: 1)
    }
    
    func downloadFailed(sender: PackageListener, errorType: NTPackageErrorType) {
        
    }
}






