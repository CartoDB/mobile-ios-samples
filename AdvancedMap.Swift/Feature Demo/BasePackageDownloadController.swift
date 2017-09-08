//
//  BasePackageDownloadController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 04/08/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class BasePackageDownloadController : BaseController, UITableViewDelegate, PackageDownloadDelegate, ClickDelegate, SwitchDelegate {
    
    var contentView: PackageDownloadBaseView!
    
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
    

    func downloadComplete(sender: PackageListener, id: String) {
        fatalError("downloadComplete function in BasePackageDownloadController should be overriden")
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
    
    func setOnlineMode() {
        contentView.hideNoPackagesBanner();
    }
    
    func setOfflineMode() {
        if (!contentView.hasLocalPackages()) {
            contentView.showNoPackagesBanner();
        }
    }

}


