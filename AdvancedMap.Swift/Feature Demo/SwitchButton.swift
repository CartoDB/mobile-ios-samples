//
//  SwitchButton.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 18/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class SwitchButton : PopupButton {
    
    var delegate: SwitchDelegate?
    
    func isOnline() -> Bool {
        return backgroundColor == Colors.green
    }
    
    convenience init(imageUrl: String) {
        self.init(frame: CGRect.zero)
        
        initialize(imageUrl: imageUrl)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.switchChanged(_:)))
        addGestureRecognizer(recognizer)
        
        backgroundColor = Colors.green
    }
    
    func switchChanged(_ sender: UITapGestureRecognizer) {
        toggle()
        delegate?.switchChanged()
    }
    
    func toggle() {
        if (backgroundColor == Colors.green) {
            backgroundColor = Colors.transparentGray
        } else {
            backgroundColor = Colors.green
        }
    }
    
}
