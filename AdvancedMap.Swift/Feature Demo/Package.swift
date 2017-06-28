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
        
        let version =  String(info.getVersion())
        
        if (isSmallerThan1MB())
        {
            status += " v." + version + " (<1MB)";
        }
        else {
            
            let size = String(describing: info.getSize() / 1024 / 1024)
            status += " v." + version + " (" + size + "MB)";
        }
        
        // Check if the package is downloaded/is being downloaded (so that status is not null)
        if (self.status != nil) {
            
            if (self.status.getCurrentAction() == NTPackageAction.PACKAGE_ACTION_READY) {
                status = "Ready";
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
    
    static let READY = "READY"
    static let QUEUED = "QUEUED"
    static let ACTION_PAUSE = "PAUSE"
    static let ACTION_RESUME = "RESUME"
    static let ACTION_CANCEL = "CANCEL"
    static let ACTION_DOWNLOAD = "DOWNLOAD"
    static let ACTION_REMOVE = "REMOVE"
    
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






