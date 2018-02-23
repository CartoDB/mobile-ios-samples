//
//  MapBaseView.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class MapBaseView : UIView {
    
    var map: NTMapView!
    
    var popup: SlideInPopup!
    
    var buttons: [PopupButton]!
    
    var infoButton: PopupButton!
    var infoContent: InformationPopupContent!
    
    var banner: Banner!
    
    let bottomLabelHeight: CGFloat = 40
    let smallPadding: CGFloat = 5
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        initialize()
    }
    
    func initialize(customMapView: NTMapView? = nil) {
        
        if (customMapView != nil) {
            map = customMapView
        } else {
            map = NTMapView()
        }
        
        addSubview(map)
        
        map.getOptions().setZoomGestures(true)
        
        popup = SlideInPopup()
        addSubview(popup)
        sendSubview(toBack: popup)
        
        infoButton = PopupButton(imageUrl: "icon_info.png")
        addButton(button: infoButton)
        
        infoContent = InformationPopupContent()
        
        map.getOptions().setPanningMode(NTPanningMode.PANNING_MODE_STICKY)
    }
    
    override func layoutSubviews() {
        
        popup.frame = bounds
        map.frame = bounds

        if (buttons != nil) {
            
            let count = CGFloat(self.buttons.count)
            
            let buttonWidth: CGFloat = 60
            let innerPadding: CGFloat = 25
            
            let totalArea = buttonWidth * count + (innerPadding * (count - 1))
            
            let w: CGFloat = buttonWidth
            let h: CGFloat = w
            let y: CGFloat = frame.height - (bottomLabelHeight + h + smallPadding)
            var x: CGFloat = frame.width / 2 - totalArea / 2
            
            for button in buttons {
                button.frame = CGRect(x: x, y: y, width: w, height: h)
                
                x += w + innerPadding
            }
        }
        
        if (banner != nil) {
            banner.frame = CGRect(x: 0, y: Device.trueY0(), width: frame.width, height: bannerHeight)
        }
    }
    
    func addRecognizers() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.infoButtonTapped(_:)))
        infoButton.addGestureRecognizer(recognizer)
    }
    
    func removeRecognizers() {
        infoButton.gestureRecognizers?.forEach(infoButton.removeGestureRecognizer)
    }
    
    @objc func infoButtonTapped(_ sender: UITapGestureRecognizer) {
        popup.setContent(content: infoContent)
        popup.popup.header.setText(text: "INFORMATION")
        popup.show()
    }
    
    func addBaseLayer() -> NTCartoOnlineVectorTileLayer {
        let layer = NTCartoOnlineVectorTileLayer(style: NTCartoBaseMapStyle.CARTO_BASEMAP_STYLE_VOYAGER)
        layer?.setPreloading(true)
        map.getLayers().add(layer)
        return layer!
    }
    
    func addGrayBaseLayer() -> NTCartoOnlineVectorTileLayer {
        let layer = NTCartoOnlineVectorTileLayer(style: NTCartoBaseMapStyle.CARTO_BASEMAP_STYLE_POSITRON)
        layer?.setPreloading(true)
        map.getLayers().add(layer)
        return layer!
    }
    
    func addDarkBaseLayer() -> NTCartoOnlineVectorTileLayer {
        let layer = NTCartoOnlineVectorTileLayer(style: NTCartoBaseMapStyle.CARTO_BASEMAP_STYLE_DARKMATTER)
        layer?.setPreloading(true)
        map.getLayers().add(layer)
        return layer!
    }
    
    func addButton(button: PopupButton) {
        
        if (buttons == nil) {
            buttons = [PopupButton]()
        }
        
        buttons.append(button)
        addSubview(button)
    }
    
    let bannerHeight: CGFloat = 45
    
    func addBanner(visible: Bool) {
        banner = Banner()
        addSubview(banner)
        banner.frame = CGRect(x: 0, y: Device.trueY0(), width: frame.width, height: bannerHeight)
        
        if (visible) {
            banner.alpha = 1
        } else {
            banner.alpha = 0
        }
    }
}





