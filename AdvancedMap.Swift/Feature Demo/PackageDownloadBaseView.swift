//
//  PackageDownloadBaseView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 11/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class PackageDownloadBaseView  : DownloadBaseView {
    
    var countryButton: PopupButton!
    
    var packageContent: PackagePopupContent!
    
    var onlineLayer: NTCartoOnlineVectorTileLayer!
    var offlineLayer: NTCartoOfflineVectorTileLayer!
    
    var manager: NTCartoPackageManager!
    
    func initializePackageDownloadContent() {
        
        countryButton = PopupButton(imageUrl: "icon_global.png")
        addButton(button: countryButton)
        
        packageContent = PackagePopupContent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func addRecognizers() {
        
        super.addRecognizers()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.countryButtonTapped(_:)))
        countryButton.addGestureRecognizer(recognizer)
    }
    
    override func removeRecognizers() {
        
        super.removeRecognizers()
        
        countryButton.gestureRecognizers?.forEach(countryButton.removeGestureRecognizer)
    }
    
    func countryButtonTapped(_ sender: UITapGestureRecognizer) {
        
        if (countryButton.isEnabled) {
            popup.setContent(content: packageContent)
            popup.popup.header.setText(text: "SELECT A PACKAGE")
            popup.show()
        }
    }
    
    func setOnlineMode() {
        map.getLayers().remove(offlineLayer)
        map.getLayers().insert(0, layer: onlineLayer)
    }
    
    func setOfflineMode(manager: NTCartoPackageManager) {
        map.getLayers().remove(onlineLayer)
        offlineLayer = NTCartoOfflineVectorTileLayer(packageManager: manager, style: .CARTO_BASEMAP_STYLE_DEFAULT)
        map.getLayers().insert(0, layer: offlineLayer)
    }
    
    func updatePackages() {
        let packages = getPackages()
        packageContent.addPackages(packages: packages)
    }
    
    func setOfflineMode() {
        setOfflineMode(manager: manager)
    }
    
    func onPackageClick(package: Package) {
        
        if (package.isGroup()) {
            folder = folder + package.name + "/"
            packageContent.addPackages(packages: getPackages())
            popup.popup.header.backButton.isHidden = false
        } else {
            
            let action = package.getActionText()
            currentDownload = package
            
            if (action == Package.ACTION_DOWNLOAD) {
                
                manager.startPackageDownload(package.id)
                progressLabel.show()
            } else if (action == Package.ACTION_PAUSE) {
                manager.setPackagePriority(package.id, priority: -1)
            } else if (action == Package.ACTION_RESUME) {
                manager.setPackagePriority(package.id, priority: 0)
            } else if (action == Package.ACTION_CANCEL) {
                manager.cancelPackageTasks(package.id)
            } else if (action == Package.ACTION_REMOVE) {
                manager.startPackageRemove(package.id)
            }
        }
    }
    
    func onStatusChanged(status: NTPackageStatus) {
        
        DispatchQueue.main.async {
            if (self.currentDownload == nil) {
                // TODO in case a download has been started and the controller is reloaded
                return
            }
            
            let text = "Downloading " + self.currentDownload.name + ": " + String(describing: status.getProgress()) + ""
            self.progressLabel.update(text: text)
            self.progressLabel.updateProgressBar(progress: CGFloat(status.getProgress()))
            
            self.currentDownload.status = self.manager.getLocalPackageStatus(self.currentDownload.id, version: -1)
            self.packageContent.findAndUpdate(package: self.currentDownload, progress: CGFloat(status.getProgress()))
        }
    }
    
    func downloadComplete(id: String) {
        DispatchQueue.main.async {
            
            if (self.currentDownload != nil) {
                self.currentDownload.status = self.manager.getLocalPackageStatus(id, version: -1)
                self.packageContent.findAndUpdate(package: self.currentDownload)
            }
        }
    }
    
    var currentDownload: Package!
    
    func onPopupBackButtonClick() {
        
        folder = folder.substring(to: folder.characters.count - 1)
        let lastslash = folder.lastIndexOf(s: "/")
        
        if (lastslash == -1) {
            folder = ""
            popup.popup.header.backButton.isHidden = true
        } else {
            folder = folder.substring(to: lastslash + 1)
        }
        
        packageContent.addPackages(packages: getPackages())
    }
    
    var folder: String = ""
    
    func getPackages() -> [Package] {
        
        var packages = [Package]()
        
        let vector = manager.getServerPackages()
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
                package.status = manager.getLocalPackageStatus(package.id, version: -1)
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








