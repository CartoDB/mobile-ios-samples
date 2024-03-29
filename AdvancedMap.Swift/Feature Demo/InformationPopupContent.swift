//
//  InformationPopupContnet.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class InformationPopupContent : UIView {
    
    var header: UILabel!
    
    var content: UILabel!
    var container: UIScrollView!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        header = UILabel()
        header.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        header.textColor = Colors.navy
        header.numberOfLines = 0
        
        addSubview(header)
        
        container = UIScrollView()
        container.showsVerticalScrollIndicator = false
        addSubview(container)
        
        content = UILabel()
        content.font = UIFont(name: "HelveticaNeue", size: 13)
        content.textColor = Colors.navyLight
        content.numberOfLines = 0
        content.textAlignment = .justified
        content.lineBreakMode = .byWordWrapping
        
        container.addSubview(content)
    }
    
    override func layoutSubviews() {
        
        let headerHeight: CGFloat = 40
        let padding: CGFloat = 5
        let sidePadding = 3 * padding
        
        let x: CGFloat = sidePadding
        var y: CGFloat = 0
        var h: CGFloat = headerHeight
        let w: CGFloat = frame.width - 2 * sidePadding
        
        header.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h + padding
        h = frame.height - (headerHeight + 3 * padding)
        
        container.frame = CGRect(x: x, y: y, width: w, height: h)
        
        // Need to set frame before, so sizeToFit() knows what the width it.
        content.frame = CGRect(x: 0, y: 0, width: container.frame.width, height: container.frame.height)
        
        content.sizeToFit()
        
        content.frame = CGRect(x: 0, y: 0, width: container.frame.width, height: content.frame.height)
        container.contentSize.height = content.frame.height
    }
    
    func setText(headerText: String, contentText: String) {
        
        header.text = headerText
        content.text = contentText
    }
    
}











