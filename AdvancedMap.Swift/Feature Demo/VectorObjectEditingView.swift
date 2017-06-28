//
//  VectorObjectEditingView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 28/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class VectorObjectEditingView : MapBaseView {
    
    var baseLayer: NTCartoOnlineVectorTileLayer!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        baseLayer = addBaseLayer()
        
        initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
