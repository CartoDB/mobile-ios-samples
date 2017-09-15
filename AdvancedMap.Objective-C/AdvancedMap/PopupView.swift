//
//  PopupView.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

@objc class PopupView : UIView {
    
    var header: SlideInPopupHeader!
    var separator: UIView!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        
        header = SlideInPopupHeader()
        addSubview(header)
        
        separator = UIView()
        separator.backgroundColor = Colors.fromRgba(red: 220, green: 220, blue: 220, alpha: 150)
        addSubview(separator)
    }
    
    override func layoutSubviews() {
        header.frame = CGRect(x: 0, y: 0, width: frame.width, height: header.height)
        
        separator.frame = CGRect(x: 0, y: header.height - 2, width: frame.width, height: 1)
    }
}
