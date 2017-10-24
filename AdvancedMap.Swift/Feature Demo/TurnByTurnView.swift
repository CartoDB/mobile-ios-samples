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
    let turnByTurnFooter = TurnByTurnFooter()
    
    var baseLayer: NTCartoOnlineVectorTileLayer!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        initialize()
        initializeDownloadContent(withSwitch: false)
        initializePackageDownloadContent()
        
        addSubview(turnByTurnBanner)
        addSubview(turnByTurnFooter)
        
        infoContent.setText(headerText: Texts.turnByTurnInfoHeader, contentText: Texts.turnByTurnInfoContainer)
        
        addBanner(visible: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height: CGFloat = 60
        
        var x: CGFloat = 0
        var y: CGFloat = Device.trueY0() - height
        let w: CGFloat = frame.width
        var h = height
        
        turnByTurnBanner.frame = CGRect(x: x, y: y, width: w, height: h)
        turnByTurnBanner.hiddenY = y
        turnByTurnBanner.visibleY = y + height
        
        x = progressLabel.frame.origin.x
        y = progressLabel.frame.origin.y + progressLabel.frame.height
        h = progressLabel.frame.height
        
        if (turnByTurnFooter.frame.isEmpty) {
            turnByTurnFooter.frame = CGRect(x: x, y: y, width: w, height: h)
        }
    }
    
}
