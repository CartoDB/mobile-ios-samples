//
//  TurnByTurnBanner.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 23/10/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class TurnByTurnBanner: UIView {
    
    let imageView = UIImageView()
    let label = UILabel()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        backgroundColor = Colors.transparentNavy
        
        addSubview(imageView)
        
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = frame.height / 6
        let imagePadding: CGFloat = 1.5 * padding
        let imageSize: CGFloat = frame.height - 2 * imagePadding
        
        var x = imagePadding
        var y = imagePadding
        var w = imageSize
        var h = imageSize
        
        imageView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x += w + imagePadding
        
        y = padding
        w = frame.width - (2 * imagePadding + padding)
        h = frame.height - 2 * padding
        
        label.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func update(text: String) {
        DispatchQueue.main.async {
            self.label.text = text.uppercased()
        }
    }
    
    func update(instruction: NTRoutingInstruction) {
        
        let action = instruction.getAction()
        let distance = Double(round(instruction.getDistance() * 100) / 100)
        
        let distanceString = String(describing: distance) + " meters"
        
        var message = ""
        var image: UIImage? = nil
        
        // There are actually even more RoutingActions, but I've covered the most prominent ones
        switch (action) {
        case NTRoutingAction.ROUTING_ACTION_ENTER_ROUNDABOUT:
            message = "Enter Roundabout in " + distanceString
        case NTRoutingAction.ROUTING_ACTION_FINISH:
            message = "You'll arrive at your destination in " + distanceString
        case NTRoutingAction.ROUTING_ACTION_GO_STRAIGHT:
            message = "Go straight for " + distanceString
        case NTRoutingAction.ROUTING_ACTION_LEAVE_ROUNDABOUT:
            message = "Leave roundabout in " + distanceString
        case NTRoutingAction.ROUTING_ACTION_STAY_ON_ROUNDABOUT:
            message = "Stay on roundabout for " + distanceString
        case NTRoutingAction.ROUTING_ACTION_TURN_LEFT:
            message = "Turn left in " + distanceString
            image = UIImage(named: "banner_icon_turn_left.png")
        case NTRoutingAction.ROUTING_ACTION_TURN_RIGHT:
            message = "Turn right in " + distanceString
            image = UIImage(named: "banner_icon_turn_right.png")
        case NTRoutingAction.ROUTING_ACTION_UTURN:
            message = "Make a U-Turn in " + distanceString
        case NTRoutingAction.ROUTING_ACTION_START_AT_END_OF_STREET:
            message = "Start at the end of the street"
        default:
            break
        }
        
        DispatchQueue.main.async {
            self.label.text = message.uppercased()
            self.imageView.image = image
        }
        
    }
    
}
