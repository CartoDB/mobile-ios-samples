//
//  ProgressLabel.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 26/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class ProgressLabel : UIView {
    
    var label: UILabel!
    var progressBar: UIView!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        backgroundColor = Colors.transparentGray
        
        label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        label.textAlignment = .center
        addSubview(label)
        
        progressBar = UIView()
        progressBar.backgroundColor = Colors.appleBlue
        addSubview(progressBar)
    }
    
    override func layoutSubviews() {
        label.frame = bounds
    }
    
    func update(progress: CGFloat, position: NTMapPos) {
        
        label.text = "DOWNLOADING" + positionToString(position: position) + " (" + String(describing: round(progress * 10) / 10) + "%)"
        
        let width: CGFloat = (frame.width * progress) / 100
        let height: CGFloat = 3
        let y: CGFloat = frame.height - height
        
        progressBar.frame = CGRect(x: 0, y: y, width: width, height: height)
    }
    
    func complete(position: NTMapPos) {
        label.text = "DOWNLOAD OF" + positionToString(position: position) + "COMPLETED"
    }
    
    func positionToString(position: NTMapPos) -> String {
        
        let lat = round(position.getX() * 100) / 100
        let lon = round(position.getY() * 100) / 100
        return  " [lat: " + String(lat) + ", lon: " + String(lon) + "] "
    }
}
