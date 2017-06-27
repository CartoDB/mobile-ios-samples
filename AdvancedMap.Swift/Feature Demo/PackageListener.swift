//
//  PackageListener.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 26/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class PackageListener : NTPackageManagerListener {
    
    var delegate: PackageDownloadDelegate?
    
    override func onPackageListUpdated() {
        delegate?.listDownloadComplete()
    }
    
    override func onPackageListFailed() {
        delegate?.listDownloadFailed()
    }
    
    override func onPackageUpdated(_ arg1: String!, version: Int32) {
        delegate?.downloadComplete(sender: self, id: arg1)
    }
    
    override func onPackageStatusChanged(_ arg1: String!, version: Int32, status: NTPackageStatus!) {
        delegate?.statusChanged(sender: self, status: status)
    }
    
    override func onPackageFailed(_ arg1: String!, version: Int32, errorType: NTPackageErrorType) {
        delegate?.downloadFailed(sender: self, errorType: errorType)
    }
}

protocol PackageDownloadDelegate {
    
    func listDownloadComplete();
    
    func listDownloadFailed();
    
    func downloadComplete(sender: PackageListener, id: String);
    
    func downloadFailed(sender: PackageListener, errorType: NTPackageErrorType);
    
    func statusChanged(sender: PackageListener, status: NTPackageStatus);
}
