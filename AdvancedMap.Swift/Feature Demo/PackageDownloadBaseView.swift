//
//  PackageDownloadBaseView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 11/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class PackageDownloadBaseView  : DownloadBaseView {
    
    static let ROUTING_FOLDER = "routingpackages"
    
    var countryButton: PopupButton!
    
    var packageContent: PackagePopupContent!
    
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
            
            if (action == Package.ACTION_DOWNLOAD) {
                manager.startPackageDownload(package.id)
                progressLabel.show()
                enqueue(package: package)
            } else if (action == Package.ACTION_PAUSE) {
                manager.setPackagePriority(package.id, priority: -1)
                dequeue(package: package)
            } else if (action == Package.ACTION_RESUME) {
                manager.setPackagePriority(package.id, priority: 0)
                enqueue(package: package)
            } else if (action == Package.ACTION_CANCEL) {
                manager.cancelPackageTasks(package.id)
                dequeue(package: package)
            } else if (action == Package.ACTION_REMOVE) {
                manager.startPackageRemove(package.id)
                dequeue(package: package)
            }
        }
    }
    
    func onStatusChanged(id: String, status: NTPackageStatus) {
        
        DispatchQueue.main.async {
            
            let download: Package? = self.getCurrentDownload()
            
            if (download != nil) {
                
                let text = "Downloading " + download!.name + ": " + String(describing: Int(status.getProgress())) + "%"
                self.progressLabel.update(text: text)
                self.progressLabel.updateProgressBar(progress: CGFloat(status.getProgress()))
                
                // Need to get it again, as else we'd be change the status of this variable,
                // not the one in the queue. However, no longer the need to null check
                self.getCurrentDownload()!.status = status
            }
            
            self.packageContent.findAndUpdate(id: id, status: status)
        }
    }
    
    func downloadComplete(id: String) {
        DispatchQueue.main.async {
            
            // TODO why won't it correctly update itself
//            let download: Package? = self.getCurrentDownload()
//            
//            if (download != nil) {
//                download!.status = self.manager.getLocalPackageStatus(id, version: -1)
//                self.packageContent.findAndUpdate(package: download!)
//                self.dequeue(package: download!)
//            }
            
            self.packageContent.addPackages(packages: self.getPackages())
            self.packageContent.table.reloadData()
        }
    }
    
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

        if (folder == Package.CUSTOM_REGION_FOLDER_NAME + "/") {
            let custom = getCustomRegionPackages()
            for package in custom {
                packages.append(package)
            }

            return packages
        }
        
        // Map package download screen's first folder features custom region packages (cities)
        if (folder.isEmpty) {
            packages.append(getCustomRegionFolder())
        }
        
        
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
    
    func getCustomRegionFolder() -> Package {
        let package = Package()
        package.name = Package.CUSTOM_REGION_FOLDER_NAME
        package.id = "NONE"
        return package
    }
    
    func getCustomRegionPackages() -> [Package] {
        var packages = [Package]()
        
        for item in Cities.list {
            let package = Package()
            package.id = item.boundingBox.toString()
            package.name = item.name
            package.status = manager.getLocalPackageStatus(package.id, version: -1)
            packages.append(package)
        }
        
        return packages
    }
    
    /*
     * Download queue
     */
 
    var downloadQueue = [Package]()
    
    func getCurrentDownload() -> Package? {
        
        if (downloadQueue.count > 0) {
            let downloading = downloadQueue.filter({ $0.isDownloading })
            if (downloading.count == 1) {
                return downloading[0]
            }
        }
        
        downloadQueue = getAllPackages().filter({ $0.isDownloading || $0.isQueued })
        
        if (downloadQueue.count > 0) {
            let downloading = downloadQueue.filter({ $0.isDownloading })

            if (downloading.count == 1) {
                return downloading[0]
            }
        }
        
        return nil
    }
    
    func enqueue(package: Package) {
        downloadQueue.append(package)
    }
    
    func dequeue() {
        downloadQueue.remove(at: 0)
    }
    
    func dequeue(package: Package) {
        downloadQueue.remove(object: package)
    }
    
    func getAllPackages() -> [Package] {
        
        var packages = [Package]()
        
        let vector = manager.getServerPackages()
        let total = Int((vector?.size())!)
        
        for i in stride(from: 0, to: total, by: 1) {
            
            let info = vector?.get(Int32(i))
            let name = info?.getName()
            
            let split = name?.components(separatedBy: "/")
            
            if (split?.count == 0) {
                continue
            }
            
            let modified = split?[(split?.count)! - 1]
            
            let package = Package()
            package.id = info?.getPackageId()
            package.name = modified
            package.status = manager.getLocalPackageStatus(package.id, version: -1)
            package.info = info
            
            packages.append(package)
        }
        
        return packages
    }
    
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}






