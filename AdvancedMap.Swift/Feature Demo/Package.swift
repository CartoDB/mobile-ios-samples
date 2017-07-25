//
//  Country.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class Package : NSObject {
    
    var id: String!
    
    var name: String!
    
    var status: NTPackageStatus!
    
    var info: NTPackageInfo!
    
    func isGroup() -> Bool {
        return status == nil && info == nil
    }
    
    func isSmallerThan1MB() -> Bool {
        return info.getSize() < (1024 * 1024);
    }
    
    func getStatusText() -> String {
        
        if (info == nil) {
            return "";
        }
        
        var status = "Available";
        
        status += getVersionAndSize()
        
        // Check if the package is downloaded/is being downloaded (so that status is not null)
        if (self.status != nil) {
            
            if (self.status.getCurrentAction() == NTPackageAction.PACKAGE_ACTION_READY) {
                status = "Ready";
                status += getVersionAndSize()
            } else if (self.status.getCurrentAction() == NTPackageAction.PACKAGE_ACTION_WAITING) {
                status = "Queued";
            } else {
                
                if (self.status.getCurrentAction() == NTPackageAction.PACKAGE_ACTION_COPYING) {
                    status = "Copying";
                } else if (self.status.getCurrentAction() == NTPackageAction.PACKAGE_ACTION_DOWNLOADING) {
                    status = "Downloading";
                } else if (self.status.getCurrentAction() == NTPackageAction.PACKAGE_ACTION_REMOVING) {
                    status = "Removing";
                }
                
                
                status += " " + String(describing: self.status.getProgress()) + "%";
            }
        }
        
        return status;
    }
    
    func getVersionAndSize() -> String {

        let version =  String(info.getVersion())
        let size = String(describing: info.getSizeInMB())
        
        if (isSmallerThan1MB()) {
            return " v." + version + " (<1MB)";
        }
        
        return " v." + version + " (" + size + " MB)";
    }
    
    static let READY = "READY"
    static let QUEUED = "QUEUED"
    static let ACTION_PAUSE = "PAUSE"
    static let ACTION_RESUME = "RESUME"
    static let ACTION_CANCEL = "CANCEL"
    static let ACTION_DOWNLOAD = "DOWNLOAD"
    static let ACTION_REMOVE = "REMOVE"
    
    var isDownloading: Bool {
        
        if (status == nil) {
            return false
        }
        
        return status.getCurrentAction() == NTPackageAction.PACKAGE_ACTION_DOWNLOADING
    }
    
    var isQueued: Bool {
        
        if (status == nil) {
            return false
        }
        
        return status.getCurrentAction() == NTPackageAction.PACKAGE_ACTION_WAITING && !status.isPaused()
    }
    
    func getActionText() -> String {
        
        if (self.info == nil) {
            return "NONE"
        }
        
        if (self.status == nil) {
            return Package.ACTION_DOWNLOAD
        }
        
        if (self.status.getCurrentAction() == NTPackageAction.PACKAGE_ACTION_READY) {
            return Package.ACTION_REMOVE
        } else if (self.status.getCurrentAction() == NTPackageAction.PACKAGE_ACTION_WAITING) {
            return Package.ACTION_CANCEL
        }
        
        if (status.isPaused()) {
            return Package.ACTION_RESUME
        } else {
            return Package.ACTION_PAUSE
        }
        
    }
}






