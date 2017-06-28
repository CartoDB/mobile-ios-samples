//
//  CountryDownloadController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class PackageDownloadController : BaseController, UITableViewDelegate, PackageDownloadDelegate, SwitchDelegate, ClickDelegate {
    
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
        
        contentView.popup.popup.header.backButton.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        contentView.packageContent.table.delegate = nil
        
        mapManager.stop(true)
        mapPackageListener = nil
        
        contentView.onlineSwitch.delegate = nil
        
        contentView.popup.popup.header.backButton.delegate = nil
    }
    
    func click(sender: UIView) {
        // Currently the only generic button on this page is the popup back button,
        // no need to type check.

        folder = folder.substring(to: folder.characters.count - 1)
        let lastslash = folder.lastIndexOf(s: "/")

        if (lastslash == -1) {
            folder = ""
            contentView.popup.popup.header.backButton.isHidden = true
        } else {
            folder = folder.substring(to: lastslash + 1)
        }
        
        contentView.packageContent.addPackages(packages: getPackages())
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
        
        let package = contentView.packageContent.packages[indexPath.row]
        
        if (package.isGroup()) {
            folder = folder + package.name + "/"
            contentView.packageContent.addPackages(packages: getPackages())
            contentView.popup.popup.header.backButton.isHidden = false
        } else {
            
            let action = package.getActionText()
            currentDownload = package
            
            if (action == Package.ACTION_DOWNLOAD) {
                
                mapManager.startPackageDownload(package.id)
                contentView.progressLabel.show()
            } else if (action == Package.ACTION_PAUSE) {
                mapManager.setPackagePriority(package.id, priority: -1)
            } else if (action == Package.ACTION_RESUME) {
                mapManager.setPackagePriority(package.id, priority: 0)
            } else if (action == Package.ACTION_CANCEL) {
                mapManager.cancelPackageTasks(package.id)
            } else if (action == Package.ACTION_REMOVE) {
                mapManager.startPackageRemove(package.id)
            }
        }
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
            
            if (self.currentDownload == nil) {
                // TODO in case a download has been started and the controller is reloaded
                return
            }
            
            let text = "Downloading " + self.currentDownload.name + ": " + String(describing: status.getProgress()) + ""
            self.contentView.progressLabel.update(text: text)
            self.contentView.progressLabel.updateProgressBar(progress: CGFloat(status.getProgress()))
            
            self.currentDownload.status = self.mapManager.getLocalPackageStatus(self.currentDownload.id, version: -1)
            self.contentView.packageContent.findAndUpdate(package: self.currentDownload, progress: CGFloat(status.getProgress()))
        }
    }
    
    func downloadComplete(sender: PackageListener, id: String) {
        DispatchQueue.main.async {
            
            if (self.currentDownload != nil) {
                self.currentDownload.status = self.mapManager.getLocalPackageStatus(id, version: -1)
                self.contentView.packageContent.findAndUpdate(package: self.currentDownload)
            }
        }
    }
    
    func downloadFailed(sender: PackageListener, errorType: NTPackageErrorType) {
        // TODO
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

            if !(name?.hasPrefix(folder))! {
                // Belongs to a different folder,
                // should not be added if name is e.g. Asia/, while folder is /Europe
                continue;
            }

            var modified = name?.substring(from: folder.characters.count)
            let index = modified?.index(of: "/")
            
            if (index == -1) {
                // This is an actual package
                package.id = info?.getPackageId()
                package.name = modified
                package.status = mapManager.getLocalPackageStatus(package.id, version: -1)
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







