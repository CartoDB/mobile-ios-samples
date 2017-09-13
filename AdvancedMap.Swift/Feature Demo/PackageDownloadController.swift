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
    
    override func viewDidLoad() {
        
        contentView = PackageDownloadView()
        view = contentView
        
        let folder = Utils.createDirectory(name: "countrypackages")
        contentView.manager = NTCartoPackageManager(source: Routing.MAP_SOURCE, dataFolder: folder)
        
        // Online mode by default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        contentView.packageContent.table.delegate = self
        
        mapPackageListener = MapPackageListener()
        mapPackageListener.delegate = self
        
        contentView.manager.setPackageManagerListener(mapPackageListener)
        contentView.manager.start()
        
        contentView.switchButton.delegate = self
        
        contentView.manager.startPackageListDownload()
        
        contentView.popup.popup.header.backButton.delegate = self
        
        if (!contentView.hasLocalPackages()) {
            let text = "Click on the globe icon to download a package"
            contentView.banner.showInformation(text: text, autoclose: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        contentView.packageContent.table.delegate = nil
        
        contentView.manager.stop(true)
        mapPackageListener = nil
        
        contentView.switchButton.delegate = nil
        
        contentView.popup.popup.header.backButton.delegate = nil
    }
    
    func click(sender: UIView) {
        // Currently the only generic button on this page is the popup back button,
        // no need to type check.
        contentView.onPopupBackButtonClick()
    }
    
    func switchChanged() {
        if (contentView.switchButton.isOnline()) {
            contentView.setOnlineMode()
        } else {
            contentView.setOfflineMode()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let package = contentView.packageContent.packages[indexPath.row]
        contentView.onPackageClick(package: package)
    }
    
    func listDownloadComplete() {
        contentView.updatePackages()
    }
    
    func listDownloadFailed() {
        // TODO
    }
    
    func statusChanged(sender: PackageListener, id: String, status: NTPackageStatus) {
        contentView.onStatusChanged(id: id, status: status)
    }
    
    func downloadComplete(sender: PackageListener, id: String) {
        contentView.downloadComplete(id: id)
    }
    
    func downloadFailed(sender: PackageListener, errorType: NTPackageErrorType) {
        // TODO
    }
}







