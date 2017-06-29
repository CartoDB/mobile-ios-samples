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
    
    convenience init(imageUrl: String) {
        self.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: imageUrl)
        
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
    
}



