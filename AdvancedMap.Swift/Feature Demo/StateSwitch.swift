//
//  OnlineSwitch.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 26/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class StateSwitch : UIView {
    
    private var _label: UILabel!
    private var _switch: UISwitch!
    
    var delegate: SwitchDelegate?
    
    func isOn() -> Bool {
        return _switch.isOn
    }
    
    func setText(text: String) {
        _label.text = text
        _label.sizeToFit()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        backgroundColor = Colors.transparentGray
        
        _label = UILabel()
        _label.textColor = UIColor.white
        _label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        _label.textAlignment = .center
        _label.text = "ONLINE"
        addSubview(_label)
        
        _switch = UISwitch()
        _switch.isOn = true
        
        addSubview(_switch)
        
        _label.sizeToFit()
        
        // Attach recognizer to the entire view so clicking would be easier
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        addGestureRecognizer(recognizer)
        
        // And disable switch, else it catches touch events
        _switch.isUserInteractionEnabled = false
    }
    
    func tapped(_ sender: UITapGestureRecognizer) {
        _switch.isOn = !_switch.isOn
        delegate?.switchChanged()
    }
    
    let padding: CGFloat = 5
    
    override func layoutSubviews() {
        
        var x: CGFloat = 2 * padding
        var y: CGFloat = 0
        var w: CGFloat = _label.frame.width
        var h: CGFloat = frame.height
        
        _label.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x += w + 2 * padding
        
        w = _switch.frame.width
        h = _switch.frame.height
        y = frame.height / 2 - h / 2
        
        _switch.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func getWidth() -> CGFloat {
        return _label.frame.width + _switch.frame.width + 6 * padding
    }
}

protocol SwitchDelegate {
    func switchChanged()
}
