//
//  StyleChoiceView.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class StyleChoiceView : MapBaseView {
    
    var popup: SlideInPopup!
    
    var infoButton: PopupButton!
    var languageButton: PopupButton!
    var baseMapButton: PopupButton!
    
    var infoContent: InformationPopupContent!
    var languageContent: InformationPopupContent!
    var baseMapContent: InformationPopupContent!
    
    convenience init() {
        
        self.init(frame: CGRect.zero)
        
        addBaseLayer()
        
        popup = SlideInPopup()
        
        infoButton = PopupButton(imageUrl: "icon_info.png")
        languageButton = PopupButton(imageUrl: "icon_language.png")
        baseMapButton = PopupButton(imageUrl: "icon_basemap.png")
        
        addButton(button: infoButton)
        addButton(button: languageButton)
        addButton(button: baseMapButton)
        
        addSubview(popup)
        sendSubview(toBack: popup)
        
        infoContent = InformationPopupContent()
        languageContent = InformationPopupContent()
        baseMapContent = InformationPopupContent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        popup.frame = bounds
    }
    
    func addRecognizers() {
        
        var recognizer = UITapGestureRecognizer(target: self, action: #selector(self.infoButtonTapped(_:)))
        infoButton.addGestureRecognizer(recognizer)
        
        recognizer = UITapGestureRecognizer(target: self, action: #selector(self.languageButtonTapped(_:)))
        languageButton.addGestureRecognizer(recognizer)
        
        recognizer = UITapGestureRecognizer(target: self, action: #selector(self.mapButtonTapped(_:)))
        baseMapButton.addGestureRecognizer(recognizer)
    }
    
    func removeRecognizers() {
        infoButton.gestureRecognizers?.forEach(infoButton.removeGestureRecognizer)
        languageButton.gestureRecognizers?.forEach(languageButton.removeGestureRecognizer)
        baseMapButton.gestureRecognizers?.forEach(baseMapButton.removeGestureRecognizer)
    }
    
    func infoButtonTapped(_ sender: UITapGestureRecognizer) {
        popup.setContent(content: infoContent)
        popup.popup.header.setText(text: "INFORMATION")
        popup.show()
    }
    
    func languageButtonTapped(_ sender: UITapGestureRecognizer) {
        popup.setContent(content: languageContent)
        popup.popup.header.setText(text: "SELECT A LANGUAGE")
        popup.show()
    }
    
    func mapButtonTapped(_ sender: UITapGestureRecognizer) {
        popup.setContent(content: baseMapContent)
        popup.popup.header.setText(text: "SELECT A BASEMAP")
        popup.show()
    }
}







