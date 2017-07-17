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
    
    var backButton: PopupBackButton!
    var label: UILabel!
    var closeButton: PopupCloseButton!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 11)
        label.textColor = Colors.navy
        
        addSubview(label)
        
        backButton = PopupBackButton()
        backButton.text.font = label.font
        backButton.text.textColor = label.textColor
        backButton.backgroundColor = UIColor.white
        
        addSubview(backButton)
        backButton.isHidden = true
        
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
        
        backButton.frame = CGRect(x: x, y: y, width: w, height: h)
        
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

class PopupBackButton : UIView {
    
    var delegate: ClickDelegate?
    
    var button: UIImageView!
    var text: UILabel!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        button = UIImageView()
        button.image = UIImage(named: "icon_back_blue.png")
        addSubview(button)
        
        text = UILabel()
        text.text = "BACK"
        addSubview(text)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.backTapped(_:)))
        addGestureRecognizer(recognizer)
    }
    
    override func layoutSubviews() {
        
        let padding: CGFloat = 3
        let imagePadding: CGFloat = frame.height / 4
        
        var x: CGFloat = 0
        var y: CGFloat = imagePadding
        var h: CGFloat = frame.height - 2 * imagePadding
        var w: CGFloat = h / 2
        
        button.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = button.frame.width + imagePadding
        y = 0
        w = frame.width - (x + padding)
        h = frame.height
        
        text.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func backTapped(_ sender: UITapGestureRecognizer) {
        delegate?.click(sender: self)
    }
}

protocol ClickDelegate {
    func click(sender: UIView);
}











