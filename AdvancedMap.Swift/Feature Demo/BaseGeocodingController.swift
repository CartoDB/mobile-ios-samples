//
//  BaseGeocodingController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 03/08/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class BaseGeocodingController : BaseController, UITableViewDelegate, PackageDownloadDelegate, ClickDelegate, SwitchDelegate {
    
    var contentView: BaseGeocodingView!
    
    var listener: PackageListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listener = PackageListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        
        listener?.delegate = self
    
        contentView.manager?.setPackageManagerListener(listener)
        contentView.manager?.start()
        contentView.manager?.startPackageListDownload()
        
        contentView.packageContent.table.delegate = self
        contentView.popup.popup.header.backButton.delegate = self
        
        contentView.switchButton.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        listener?.delegate = nil
        
        contentView.manager?.setPackageManagerListener(nil)
        contentView.manager?.stop(false)
        
        contentView.switchButton.delegate = nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let package = contentView.packageContent.packages[indexPath.row]
        contentView.onPackageClick(package: package)
    }
    
    func click(sender: UIView) {
        // Currently the only generic button on this page is the popup back button,
        // no need to type check.
        contentView.onPopupBackButtonClick()
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
        DispatchQueue.main.async {
            let package = self.contentView.manager?.getLocalPackage(id)!
            let text = "DOWNLOADED MAP (" + String(describing: (package?.getSizeInMB())!) + "MB)"
            self.contentView.progressLabel.complete(message: text)
            
            (self.contentView as! GeocodingView).showSearchBar()
        }
    }
    
    func downloadFailed(sender: PackageListener, errorType: NTPackageErrorType) {
        // TODO
    }
    
    func switchChanged() {
        
        if (contentView.switchButton.isOnline()) {
            setOnlineMode()
        } else {
            setOfflineMode()
        }
    }
    
    let API_KEY = "mapzen-e2gmwsC"
    
    func setOnlineMode() { }
    
    func setOfflineMode() { }
    
}




