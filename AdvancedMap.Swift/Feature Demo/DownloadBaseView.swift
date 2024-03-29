//
//  DownloadBaseView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import CartoMobileSDK

class DownloadBaseView : MapBaseView {
    
    var progressLabel: ProgressLabel!
    
    var projection: NTProjection!
    
    var onlineLayer: NTCartoOnlineVectorTileLayer!
    var offlineLayer: NTCartoOfflineVectorTileLayer!
    
    var switchButton: SwitchButton!
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let w: CGFloat = frame.width
        let h: CGFloat = bottomLabelHeight
        let x: CGFloat = 0
        let y: CGFloat = frame.height - h
        
        progressLabel.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    override func addRecognizers() {
        super.addRecognizers()
    }
    
    override func removeRecognizers() {
        super.removeRecognizers()
    }

    func initializeDownloadContent(withSwitch: Bool = true, withBaseLayer: Bool = true) {
        
        if (withBaseLayer) {
            onlineLayer = addBaseLayer()
        }
        
        progressLabel = ProgressLabel()
        addSubview(progressLabel)
        
        projection = map.getOptions().getBaseProjection()
        
        if (withSwitch) {
            switchButton = SwitchButton(onImageUrl: "icon_wifi_on.png", offImageUrl: "icon_wifi_off.png")
            addButton(button: switchButton)
        }
        
        bringSubview(toFront: infoButton)
    }
    
    func setOnlineMode() {
        if (offlineLayer != nil) {
            map.getLayers().remove(offlineLayer)
        }
        
        if (onlineLayer == nil) {
            onlineLayer = NTCartoOnlineVectorTileLayer(style: .CARTO_BASEMAP_STYLE_VOYAGER)
        }
        
        map.getLayers().insert(0, layer: onlineLayer)
    }
    
    func setOfflineMode(manager: NTCartoPackageManager) {
        
        if (onlineLayer != nil) {
            map.getLayers().remove(onlineLayer)
        }
        
        if (offlineLayer == nil) {
            offlineLayer = NTCartoOfflineVectorTileLayer(packageManager: manager, style: .CARTO_BASEMAP_STYLE_VOYAGER)
            offlineLayer?.setPreloading(true)
        }
        
        map.getLayers().insert(0, layer: offlineLayer)
    }

    
}




