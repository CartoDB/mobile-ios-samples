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
}
