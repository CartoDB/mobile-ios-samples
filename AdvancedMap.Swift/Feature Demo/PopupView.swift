//
//  PopupView.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class PopupView : UIView {
    
    var header: SlideInPopupHeader!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        
        header = SlideInPopupHeader()
        addSubview(header)
    }
    
    override func layoutSubviews() {
        header.frame = CGRect(x: 0, y: 0, width: frame.width, height: header.height)
    }
}
