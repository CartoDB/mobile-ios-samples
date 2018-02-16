//
//  PopupButton.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class PopupButton : UIView {
    
    let duration: Double = 200

    var imageView: UIImageView!
    var image: UIImage!
    
    convenience init(imageUrl: String) {
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
    
    var imagePadding: CGFloat = -1
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 2
        
        if (imagePadding == -1) {
            imagePadding = frame.height / 3.5
        }
        
        imageView.frame = CGRect(x: imagePadding, y: imagePadding, width: frame.width - 2 * imagePadding, height: frame.height - 2 * imagePadding)
        
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
    
}



