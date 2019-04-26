//
//  PopupButton.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

@objc class PopupButton : UIView {
    
    let duration: Double = 200

    var imageView: UIImageView!
    var image: UIImage!
    
    @objc convenience init(imageUrl: String) {
        self.init(frame: CGRect.zero)
        
        initialize(imageUrl: imageUrl)
    }
    
    func initialize(imageUrl: String) {
        backgroundColor = UIColor.white
        
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        image = UIImage(named: imageUrl)
        imageView.image = image
        
        addSubview(imageView)
    }
    
    var isEnabled = true
    
    func enable() {
        isEnabled = true
        alpha = 1.0
    }
    
    func disable() {
        isEnabled = false
        alpha = 0.5
    }
    
    override func layoutSubviews() {

        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 2
        
        let padding: CGFloat = frame.height / 3.5
        
        imageView.frame = CGRect(x: padding, y: padding, width: frame.width - 2 * padding, height: frame.height - 2 * padding)
        
        addRoundShadow()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 0.5
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (!isEnabled) {
            return
        }
        
        alpha = 1.0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (!isEnabled) {
            return
        }
        
        alpha = 1.0
    }
    
    func addRoundShadow() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset =  CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 0.0
        layer.masksToBounds = false
        layer.cornerRadius = frame.width / 2
    }
    
}



