//
//  Banner.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 24/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

@objc class Banner: AlertBaseView {
    
    let imageView = UIImageView()
    let label = UILabel()
    
    var rightItem: UIImageView?
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        backgroundColor = Colors.darkTransparentGray
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "banner_icon_info.png")
        addSubview(imageView)
        
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        addSubview(label)
    }
    
    override func layoutSubviews() {
        
        let padding: CGFloat = frame.height / 4
        
        var x = padding
        var y = padding
        var w = frame.height - 2 * padding
        var h = w
        
        imageView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        if (rightItem != nil) {
            x = frame.width - (w + 2 * padding)
            rightItem?.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        
        x += w + padding
        y = 0
        w = frame.width - (2 * x)
        h = frame.height
        
        label.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func addRightItem(item: UIImageView) {
        rightItem = item
        addSubview(rightItem!)
        layoutSubviews()
    }
    
    func show(text: String) {
        label.text = text
        show()
    }
    
    func showInformation(text: String, autoclose: Bool) {
        show(text: text)
        
        if (superview != nil) {
            superview?.bringSubview(toFront: self)
        }
        
        if (autoclose) {
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.hide), userInfo: nil, repeats: false)
        }
    }
}
