//
//  GalleryRow.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class GalleryRow : UIView {
    
    var imageView: UIImageView!
    var titleView: UILabel!
    var descriptionView: UILabel!
    
    var sample: Sample!
    
    convenience init() {
        
        self.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        
        layer.borderWidth = 1;
        layer.borderColor = Colors.nearWhite.cgColor
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        addSubview(imageView)
        
        titleView = UILabel()
        titleView.textColor = Colors.appleBlue
        titleView.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        addSubview(titleView)
        
        descriptionView = UILabel()
        descriptionView.textColor = UIColor.lightGray
        descriptionView.font = UIFont(name: "HelveticaNeue", size: 12)
        descriptionView.lineBreakMode = .byWordWrapping
        descriptionView.numberOfLines = 0
        
        addSubview(descriptionView)
    }
    
    override func layoutSubviews() {
        
        let padding: CGFloat = 5.0
        
        let imageHeight = frame.height / 5 * 3
        
        titleView.sizeToFit()
        descriptionView.sizeToFit()
        
        let titleHeight = titleView.frame.height
        let descriptionHeight = descriptionView.frame.height
        
        let x = padding
        var y = padding
        let w = frame.width - 2 * padding
        var h = imageHeight
        
        imageView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h + padding;
        h = titleHeight
        
        titleView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h + padding
        h = descriptionHeight
        
        descriptionView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        addSquareShadow()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 0.5
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 1.0
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 1.0
        super.touchesCancelled(touches, with: event)
    }
    
    func update(sample: Sample) {
        
        self.sample = sample
        
        imageView.image = UIImage(named: sample.imageResource!)
        titleView.text = sample.title
        descriptionView.text = sample.description
        
    }
}
