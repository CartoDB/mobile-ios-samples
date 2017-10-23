//
//  TurnByTurnInformationLabel.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 23/10/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class TurnByTurnInformationLabel: UIView {
    
    let label = UILabel()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    func update(result: NTRoutingResult) {
        let distance = result.getTotalDistance()
        let time = result.getTotalTime()
        
        label.text = distance.description + "; " + time.description
    }
}
