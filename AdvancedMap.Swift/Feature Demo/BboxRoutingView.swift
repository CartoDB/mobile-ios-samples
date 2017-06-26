//
//  BboxRoutingView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 22/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class BboxRoutingView : MapBaseView {
    
    var mapLayer: NTVectorTileLayer!
    
    var onlineSwitch: StateSwitch!
    
    var downloadButton: PopupButton!
    
    var progressLabel: ProgressLabel!
    
    convenience init() {
        
        self.init(frame: CGRect.zero)
        
        mapLayer = addBaseLayer()
        
        initialize()

        infoContent.setText(headerText: Texts.bboxRoutingInfoHeader, contentText: Texts.basemapInfoContainer)
        
        onlineSwitch = StateSwitch()
        addSubview(onlineSwitch)
        
        downloadButton = PopupButton(imageUrl: "icon_download.png")
        addButton(button: downloadButton)
        
        progressLabel = ProgressLabel()
        addSubview(progressLabel)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let padding: CGFloat = 5
        
        var w: CGFloat = onlineSwitch.getWidth()
        let h: CGFloat = 40
        var x: CGFloat = frame.width - (w + padding)
        var y: CGFloat = Device.trueY0() + padding
        
        onlineSwitch.frame = CGRect(x: x, y: y, width: w, height: h)
        
        w = frame.width
        x = 0
        y = frame.height - h
        
        progressLabel.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func downloadButtonTapped(_ sender: UITapGestureRecognizer) {
        if (progressLabel.isVisible()) {
            progressLabel.hide()
        } else {
            progressLabel.show()
        }
    }
    
    override func addRecognizers() {
        
        super.addRecognizers()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.downloadButtonTapped(_:)))
        downloadButton.addGestureRecognizer(recognizer)
    }
    
    override func removeRecognizers() {
        
        super.removeRecognizers()
        
        downloadButton.gestureRecognizers?.forEach(downloadButton.removeGestureRecognizer)
    }
}




