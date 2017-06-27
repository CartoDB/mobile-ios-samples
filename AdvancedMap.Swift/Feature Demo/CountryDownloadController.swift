//
//  CountryDownloadController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class CountryDownloadController : BaseController, UITableViewDelegate, PackageDownloadDelegate, SwitchDelegate {
    
    var contentView: CountryDownloadView!
    
    var mapPackageListener: MapPackageListener!
    var mapManager: NTCartoPackageManager!
    
    override func viewDidLoad() {
        
        contentView = CountryDownloadView()
        view = contentView
        
        let folder = Utils.createDirectory(name: "countrypackages")
        mapManager = NTCartoPackageManager(source: Routing.MAP_SOURCE, dataFolder: folder)
        
        // Online mode by default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        contentView.countryContent.table.delegate = self
        
        mapPackageListener = MapPackageListener()
        mapPackageListener.delegate = self
        mapManager.setPackageManagerListener(mapPackageListener)
        mapManager.start()
        
        contentView.onlineSwitch.delegate = self
        
        mapManager.startPackageListDownload()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        contentView.countryContent.table.delegate = nil
        
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
    
    var currentDownload: Country!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.popup.hide()
        
        let country = contentView.countryContent.countries[indexPath.row]
        currentDownload = country
        
        let id = country.id
        mapManager.startPackageDownload(id)
        
        contentView.progressLabel.show()
    }
    
    func listDownloadComplete() {
        let countries = getCountries()
        contentView.countryContent.addCountries(countries: countries)
    }
    
    func listDownloadFailed() {
        // TODO
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
    
    var currentFolder: String = ""
    
    func getCountries() -> [Country] {
        
        var countries = [Country]()
        
        let packages = mapManager.getServerPackages()
        let packageCount = Int((packages?.size())!)
        
        for i in stride(from: 0, to: packageCount, by: 1) {
            
            let info = packages?.get(Int32(i))
            let names = info?.getNames("")
            let nameCount = Int((names?.size())!)
            
            for j in stride(from: 0, to: nameCount, by: 1) {
                let country = Country()
                country.name = names?.get(Int32(j))
                countries.append(country)
            }
            
        }
        
        return countries
    }
}







