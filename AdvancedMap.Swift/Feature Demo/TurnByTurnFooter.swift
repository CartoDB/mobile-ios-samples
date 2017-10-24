//
//  TurnByTurnInformationLabel.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 23/10/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class TurnByTurnFooter: UIView {
    
    let label = UILabel()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        backgroundColor = Colors.transparentNavy
        
        label.textColor = UIColor.white
        label.font = UIFont(name: "HelveticaNeue", size: 11)
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 5
        label.frame = CGRect(x: padding, y: 0, width: frame.width - 2 * padding, height: frame.height)
        
        hiddenY = frame.origin.y
        visibleY = hiddenY - frame.height
    }
    
    func update(result: NTRoutingResult) {
        let rawDistance = result.getTotalDistance()
        let rawTime = result.getTotalTime()
        
        var parsedDistance = ""
        var parsedTime = ""
        
        if (rawDistance > 1000) {
            // Use different unit of measurement if it's greater one kilometer
            parsedDistance = Double(round(rawDistance * 10) / 10).description + " km"
        } else {
            parsedDistance = Double(round(rawDistance * 10) / 10).description + " meters"
        }
        
        let minute = 60.0
        let hour = 60.0 * minute
        
        if (rawTime > hour) {
            // Use different unit of measurement if it's greater than one hour
            parsedTime = (Double(round(rawDistance * 100 / hour) / 100)).description + " hours"
        } else {
            parsedTime = (Double(round(rawDistance * 100 / minute) / 100)).description + " minutes"
        }
        
        DispatchQueue.main.async {
            self.label.text = (parsedDistance + ". You'll arrive in " + parsedTime).uppercased()
            self.show()
        }
    }
    
    var visibleY: CGFloat = 0
    var hiddenY: CGFloat = 0
    
    func show() {
        UIView.animate(withDuration: 0.2, animations: {
            self.frame = CGRect(x: self.frame.origin.x, y:  self.visibleY, width:  self.frame.width, height:  self.frame.height)
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.2, animations: {
            self.frame = CGRect(x:  self.frame.origin.x, y:  self.hiddenY, width:  self.frame.width, height:  self.frame.height)
        })
    }
}



