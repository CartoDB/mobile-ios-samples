//
//  Utils.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class Utils {
    
    static func createDirectory(name: String) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let folder = path + "/" + name
        
        do {
            try FileManager.default.createDirectory(atPath: folder, withIntermediateDirectories: false, attributes: nil)
        } catch {
            // Folder already exists, nothing to catch
        }
        
        return folder
    }
    
    static func pathToBitmap(path: String) -> NTBitmap {
        return NTBitmapUtils.createBitmap(from: UIImage(named: path))
    }
}
