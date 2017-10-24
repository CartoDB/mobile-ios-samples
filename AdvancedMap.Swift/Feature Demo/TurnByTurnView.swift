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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height: CGFloat = 60
        turnByTurnBanner.frame = CGRect(x: 0, y: Device.trueY0(), width: frame.width, height: height)
        
        turnByTurnFooter.frame = progressLabel.frame
    }
    
}
