//
//  CountryDownloadController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class PackageDownloadController : BaseController, UITableViewDelegate, PackageDownloadDelegate, SwitchDelegate {
    
    var contentView: PackageDownloadView!
    
    var mapPackageListener: MapPackageListener!
    var mapManager: NTCartoPackageManager!
    
    override func viewDidLoad() {
        
        contentView = PackageDownloadView()
        view = contentView
        
        let folder = Utils.createDirectory(name: "countrypackages")
        mapManager = NTCartoPackageManager(source: Routing.MAP_SOURCE, dataFolder: folder)
        
        // Online mode by default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        contentView.packageContent.table.delegate = self
        
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
        
        contentView.packageContent.table.delegate = nil
        
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
    
    var currentDownload: Package!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.popup.hide()
        
        let country = contentView.packageContent.packages[indexPath.row]
        currentDownload = country
        
        let id = country.id
        mapManager.startPackageDownload(id)
        
        contentView.progressLabel.show()
    }
    
    func listDownloadComplete() {
        let packages = getPackages()
        contentView.packageContent.addPackages(packages: packages)
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
    
    var folder: String = ""
    
    func getPackages() -> [Package] {

        var packages = [Package]()
        
        let vector = mapManager.getServerPackages()
        let total = Int((vector?.size())!)
        
        for i in stride(from: 0, to: total, by: 1) {
            
            let info = vector?.get(Int32(i))
            let name = info?.getName()
            
            let package = Package()

            if folder.characters.count > 0 && (name?.hasPrefix(folder))! {
                // Belongs to a different folder,
                // should not be added if name is e.g. Asia/, while folder is /Europe
                continue;
            }
            
            var modified = name?.substring(from: folder.characters.count)
            let index = modified?.index(of: "/")
            
            if (index == -1) {
                // This is an actual package
                package.name = modified
                package.status = mapManager.getLocalPackageStatus(info?.getPackageId(), version: -1)
                package.info = info
            } else {
                // This is a package group
                modified = modified?.substring(from: 0, to: index!)
                
                // Try n' find an existing package from the list
                let found = packages.filter({ $0.name == modified })
                
                if found.count == 0 {
                    // If there are none, add a package group if we don't have an existing list item
                    package.name = modified
                } else if found.count == 1 && found[0].info != nil {
                    
                    // Sometimes we need to add two labels with the same name.
                    // One a downloadable package and the other pointing to a list of said country's counties,
                    // such as with Spain, Germany, France, Great Britain
                    
                    // If there is one existing package and its info isn't null,
                    // we will add a "parent" package containing subpackages (or package group)
                    package.name = modified
                } else {
                    // Shouldn't be added, as both cases are accounted for
                    continue
                }
            }

            packages.append(package)
        }
        
        return packages
    }
}







