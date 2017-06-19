//
//  SlideInPopupHeader.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class SlideInPopupHeader : UIView {
    
    var height: CGFloat = 40
    
    var label: UILabel!
    var closeButton: PopupCloseButton!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 11)
        label.textColor = Colors.navy
        
        addSubview(label)
        
        closeButton = PopupCloseButton()
        addSubview(closeButton)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.closeTapped(_:)))
        closeButton.addGestureRecognizer(recognizer)
    }
    
    override func layoutSubviews() {
        
        let padding: CGFloat = 10
        
        var x: CGFloat = padding
        let y: CGFloat = 0
        var w: CGFloat = label.frame.width
        let h: CGFloat = frame.height
        
        label.frame = CGRect(x: x, y: y, width: w, height: h)
        
        w = h
        x = frame.width - w
        
        closeButton.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func setText(text: String) {
        label.text = text
        label.sizeToFit()
        layoutSubviews()
    }
    
    func closeTapped(_ sender: UITapGestureRecognizer) {
        (superview?.superview as? SlideInPopup)?.hide()
    }
}

class PopupCloseButton : UIView {
    
    var imageView: UIImageView!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        imageView = UIImageView()
        imageView.image = UIImage(named: "icon_close.png")
        
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        
        let padding: CGFloat = frame.height / 3
        
        imageView.frame = CGRect(x: padding, y: padding, width: frame.width - 2 * padding, height: frame.height - 2 * padding)
    }
}



