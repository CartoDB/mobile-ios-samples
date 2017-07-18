//
//  ReverseGeocodingController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 06/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class ReverseGecodingController : BaseController, ReverseGeocodingEventDelegate, UITableViewDelegate, PackageDownloadDelegate, ClickDelegate {
    
    var contentView: ReverseGeocodingView!
    
    var geocodingListener: ReverseGeocodingEventListener!
    var packageListener: PackageListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = ReverseGeocodingView()
        view = contentView
        
        geocodingListener = ReverseGeocodingEventListener()
        geocodingListener.projection = contentView.projection
        
        packageListener = PackageListener()
        
        let folder = Utils.createDirectory(name: "geocodingpackages")
        contentView.manager = NTCartoPackageManager(source: BaseGeocodingView.SOURCE, dataFolder: folder)

        geocodingListener.service = NTPackageManagerReverseGeocodingService(packageManager: contentView.manager)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        
        geocodingListener.delegate = self
        packageListener?.delegate = self
        
        contentView.map.setMapEventListener(geocodingListener)
        
        contentView.manager?.setPackageManagerListener(packageListener)
        contentView.manager?.start()
        contentView.manager?.startPackageListDownload()
        
        contentView.packageContent.table.delegate = self
        contentView.popup.popup.header.backButton.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        geocodingListener.delegate = nil
        packageListener?.delegate = nil
        
        contentView.map.setMapEventListener(nil)
        
        contentView.manager?.setPackageManagerListener(nil)
        contentView.manager?.stop(false)
        
        contentView.packageContent.table.delegate = nil
        contentView.popup.popup.header.backButton.delegate = nil
    }
    
    func foundResult(result: NTGeocodingResult!) {

        if (result == nil) {
            alert(message: "Couldn't find any addresses. Are you sure you have downloaded the region you're trying to reverse geocode?")
            return
        }
        
        let title = ""
        let description = result.description()!

        let goToPosition = false
        
        contentView.showResult(result: result, title: title, description: description, goToPosition: goToPosition)
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
    
    func statusChanged(sender: PackageListener, status: NTPackageStatus) {
        contentView.onStatusChanged(status: status)
    }
    
    func downloadComplete(sender: PackageListener, id: String) {
        contentView.downloadComplete(id: id)
    }
    
    func downloadFailed(sender: PackageListener, errorType: NTPackageErrorType) {
        // TODO
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let package = contentView.packageContent.packages[indexPath.row]
        contentView.onPackageClick(package: package)
    }
    
}








