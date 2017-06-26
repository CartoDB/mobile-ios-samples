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
    
    override func onPackageUpdated(_ arg1: String!, version: Int32) {
        delegate?.downloadComplete(id: arg1)
    }
    
    override func onPackageStatusChanged(_ arg1: String!, version: Int32, status: NTPackageStatus!) {
        delegate?.statusChanged(status: status)
    }
    
    override func onPackageFailed(_ arg1: String!, version: Int32, errorType: NTPackageErrorType) {
        delegate?.downloadFailed(errorType: errorType)
    }
}

protocol PackageDownloadDelegate {
    
    func downloadComplete(id: String);
    
    func downloadFailed(errorType: NTPackageErrorType);
    
    func statusChanged(status: NTPackageStatus);
}
