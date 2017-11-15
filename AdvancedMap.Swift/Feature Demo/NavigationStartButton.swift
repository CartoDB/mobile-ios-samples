//
//  NavigationStartButton.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 15/11/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class NavigationStartButton: PopupButton {
    
    var delegate: SwitchDelegate?
    
    let label = UILabel()
    
    var isStopped: Bool {
        get {
            return label.text == startText
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        initialize(imageUrl: "onImageUrl")
        
        label.textColor = UIColor.white
        label.font = UIFont(name: "HelveticaNeue", size: 10)
        label.textAlignment = .center
        label.clipsToBounds = true
        
        addSubview(label)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.switchChanged(_:)))
        addGestureRecognizer(recognizer)
        
        toggle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    func switchChanged(_ sender: UITapGestureRecognizer) {
        delegate?.switchChanged()
        toggle()
    }
    
    let startText = "START"
    let stopText = "STOP"
    
    func toggle() {
        if (isStopped) {
            label.text = stopText
            backgroundColor = Colors.locationRed
        } else {
            label.text = startText
            backgroundColor = Colors.green
        }
    }
}
