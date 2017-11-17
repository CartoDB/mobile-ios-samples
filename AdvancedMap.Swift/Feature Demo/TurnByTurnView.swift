//
//  TurnByTurnView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 09/10/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class TurnByTurnView : PackageDownloadBaseView {
    
    let turnByTurnBanner = TurnByTurnBanner()
    let startButton = NavigationStartButton()
    
    var baseLayer: NTCartoOnlineVectorTileLayer!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        initialize()
        initializeDownloadContent(withSwitch: false)
        initializePackageDownloadContent()
        
        addSubview(turnByTurnBanner)
        addButton(button: startButton)
        
        infoContent.setText(headerText: Texts.turnByTurnInfoHeader, contentText: Texts.turnByTurnInfoContainer)
        
        addBanner(visible: false)
        
        let decoder = onlineLayer.getTileDecoder() as! NTMBVectorTileDecoder
        decoder.setStyleParameter("buildings", value: "2")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height: CGFloat = 90
        
        let x: CGFloat = 0
        let y: CGFloat = Device.trueY0() - height
        let w: CGFloat = frame.width
        let h = height
        
        turnByTurnBanner.frame = CGRect(x: x, y: y, width: w, height: h)
        turnByTurnBanner.hiddenY = y
        turnByTurnBanner.visibleY = y + height
    }
    
}
