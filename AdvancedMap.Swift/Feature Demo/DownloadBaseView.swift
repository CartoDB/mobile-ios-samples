//
//  DownloadBaseView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class DownloadBaseView : MapBaseView {
    
    var onlineSwitch: StateSwitch!
    
    var progressLabel: ProgressLabel!
    
    var projection: NTProjection!
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 5
        
        var w: CGFloat = onlineSwitch.getWidth()
        var h: CGFloat = 40
        var x: CGFloat = frame.width - (w + padding)
        var y: CGFloat = Device.trueY0() + padding
        
        onlineSwitch.frame = CGRect(x: x, y: y, width: w, height: h)
        
        w = frame.width
        h = bottomLabelHeight
        x = 0
        y = frame.height - h
        
        progressLabel.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func initializeDownloadContent() {
        
        onlineSwitch = StateSwitch()
        addSubview(onlineSwitch)
        
        progressLabel = ProgressLabel()
        addSubview(progressLabel)
        
        projection = map.getOptions().getBaseProjection()
    }
}
