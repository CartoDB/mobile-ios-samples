//
//  PackageCell.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 28/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class PackageCell : UITableViewCell {
    
    var package: Package!
    
    var title: UILabel!
    var subtitle: UILabel!
    var statusIndicator: UILabel!
    var forwardIcon: UIImageView!
    
    var progressIndicator: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 13)
        let titleColor = Colors.navy
        
        textLabel?.font = titleFont
        textLabel?.textColor = titleColor
        
        title = UILabel()
        title.textColor = titleColor
        title.font = titleFont
        addSubview(title)
        
        subtitle = UILabel()
        subtitle.textColor = UIColor.lightGray
        subtitle.font = UIFont(name: "HelveticaNeue", size: 11)
        addSubview(subtitle)
        
        statusIndicator = UILabel()
        statusIndicator.textAlignment = .center
        statusIndicator.textColor = Colors.appleBlue
        statusIndicator.font = UIFont(name: "HelveticaNeue-Bold", size: 11)
        statusIndicator.layer.cornerRadius = 5
        statusIndicator.layer.borderColor = statusIndicator.textColor.cgColor
        addSubview(statusIndicator)
        
        forwardIcon = UIImageView()
        forwardIcon.image = UIImage(named: "icon_forward_blue.png")
        addSubview(forwardIcon)
        
        progressIndicator = UIView()
        progressIndicator.backgroundColor = Colors.appleBlue
        addSubview(progressIndicator)
    }
    
    let leftPadding: CGFloat = 15
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
 
        if (package.isGroup()) {
            title.frame = CGRect.zero
            subtitle.frame = CGRect.zero
            statusIndicator.frame = CGRect.zero
            progressIndicator.frame = CGRect.zero
            
            let h: CGFloat = frame.height / 3
            let w: CGFloat = h / 2
            let x: CGFloat = frame.width - (w + leftPadding)
            let y: CGFloat = frame.height / 2 - h / 2
            
            forwardIcon.frame = CGRect(x: x, y: y, width: w, height: h)
            
            return
        }
        
        title.sizeToFit()
        subtitle.sizeToFit()
        statusIndicator.sizeToFit()
        
        let topPadding: CGFloat = (frame.height - (title.frame.height + subtitle.frame.height)) / 2
        
        let titleWidth: CGFloat = frame.width * 0.66
        
        var x: CGFloat = leftPadding
        var y: CGFloat = topPadding
        var w: CGFloat = titleWidth
        var h: CGFloat = title.frame.height
        
        title.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h
        
        subtitle.frame = CGRect(x: x, y: y, width: w, height: h)
        
        w = 82
        h = frame.height / 3 * 2
        x = frame.width - (w + leftPadding)
        y = frame.height / 2 - h / 2
        
        statusIndicator.frame = CGRect(x: x, y: y, width: w, height: h)
        
        progressIndicator.frame = CGRect(x: progressIndicator.frame.origin.x, y: progressIndicator.frame.origin.y, width: progressIndicator.frame.width, height: progressIndicator.frame.height)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(package: Package) {
        
        self.package = package
        
        if (package.isGroup()) {
            // It's a package group. These are displayed with a single label
            textLabel?.text = package.name.uppercased()
            forwardIcon.isHidden = false
            return
        }
        
        forwardIcon.isHidden = true
        
        // "Hide" the original label, as these aren't used in advanced cells
        textLabel?.text = ""
        
        title.text = package.name.uppercased()
        subtitle.text = package.getStatusText()
        
        let action = package.getActionText()
        statusIndicator.text = action
        
        if (action == Package.ACTION_DOWNLOAD) {
            statusIndicator.layer.borderWidth = 1
        } else {
            statusIndicator.layer.borderWidth = 0
        }
        
        if (self.package.status == nil) {
            progressIndicator.frame = CGRect.zero
            return
        }
        
        if (self.package.status.getCurrentAction() != NTPackageAction.PACKAGE_ACTION_DOWNLOADING) {
            progressIndicator.frame = CGRect.zero
        }
    }
    
    func update(package: Package, progress: CGFloat) {
        
        update(package: package)
        
        let width: CGFloat = ((frame.width - 2 * leftPadding) * progress) / 100
        let height: CGFloat = 1
        let y: CGFloat = frame.height - 4

        progressIndicator.frame = CGRect(x: leftPadding, y: y, width: width, height: height)
    }
}





