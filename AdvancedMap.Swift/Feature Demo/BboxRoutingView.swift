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
    
    convenience init() {
        
        self.init(frame: CGRect.zero)
        
        mapLayer = addBaseLayer()
        
        initialize()

        infoContent.setText(headerText: Texts.bboxRoutingInfoHeader, contentText: Texts.basemapInfoContainer)
        
        onlineSwitch = StateSwitch()
        addSubview(onlineSwitch)
        
        downloadButton = PopupButton(imageUrl: "icon_download.png")
        addButton(button: downloadButton)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let padding: CGFloat = 5
        
        let w: CGFloat = onlineSwitch.getWidth()
        let h: CGFloat = 40
        let x: CGFloat = frame.width - (w + padding)
        let y: CGFloat = padding
        
        onlineSwitch.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func downloadButtonTapped(_ sender: UITapGestureRecognizer) {

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




