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
    let instructionLabel = UILabel()
    let separator = UIView()
    
    let routeDistanceInfoLabel = UILabel()
    let routeTimeInfoLabel = UILabel()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        backgroundColor = Colors.navyLight
        
        addSubview(imageView)
        
        instructionLabel.textAlignment = .left
        instructionLabel.textColor = UIColor.white
        instructionLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        instructionLabel.numberOfLines = 0
        instructionLabel.lineBreakMode = .byWordWrapping
        addSubview(instructionLabel)
        
        separator.backgroundColor = UIColor.white
        addSubview(separator)
        
        routeDistanceInfoLabel.textColor = UIColor.white
        routeDistanceInfoLabel.font = UIFont(name: "HelveticaNeue", size: 9)
        addSubview(routeDistanceInfoLabel)
        
        routeTimeInfoLabel.textColor = UIColor.white
        routeTimeInfoLabel.font = UIFont(name: "HelveticaNeue", size: 9)
        addSubview(routeTimeInfoLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 8
        let topLabelHeight = (frame.height / 3 * 2) - padding
        
        let imageSize: CGFloat = topLabelHeight - 2 * padding
        
        var x = padding
        var y = padding
        var w = imageSize
        var h = imageSize
        
        imageView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x += w + padding
        w = frame.width - (3 * padding)
        
        instructionLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h + padding
        x = padding
        h = 1
        w = frame.width - 2 * padding
        
        separator.frame = CGRect(x: x, y: y, width: w, height: h)
        
        let smallPadding = padding / 2
        y += h + smallPadding
        
        let remaining = frame.height - (y + smallPadding)
        
        h = remaining / 2
        
        routeDistanceInfoLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        y += h
        routeTimeInfoLabel.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func updateInstruction(text: String) {
        DispatchQueue.main.async {
            self.instructionLabel.text = text.uppercased()
        }
    }
    
    func updateInstruction(current: NTRoutingInstruction, next: NTRoutingInstruction?) {
        
        let action = current.getAction()
        let distance = Double(round(current.getDistance() * 100) / 100)
        
        let distanceString = String(describing: distance) + " meters"
        
        var message = ""
        var image: UIImage? = nil
        
        // There are actually even more RoutingActions, but I've covered the most prominent ones
        switch (action) {
        case NTRoutingAction.ROUTING_ACTION_ENTER_ROUNDABOUT:
            message = "Enter Roundabout in " + distanceString
        case NTRoutingAction.ROUTING_ACTION_FINISH:
            message = "You'll arrive at your destination in " + distanceString
            image = UIImage(named: "icon_banner_finish.png")
        case NTRoutingAction.ROUTING_ACTION_GO_STRAIGHT:
            message = "Go straight for " + distanceString
        case NTRoutingAction.ROUTING_ACTION_LEAVE_ROUNDABOUT:
            message = "Leave roundabout in " + distanceString
        case NTRoutingAction.ROUTING_ACTION_STAY_ON_ROUNDABOUT:
            message = "Stay on roundabout for " + distanceString
        case NTRoutingAction.ROUTING_ACTION_TURN_LEFT:
            message = "in " + distanceString
            image = UIImage(named: "banner_icon_turn_left.png")
        case NTRoutingAction.ROUTING_ACTION_TURN_RIGHT:
            message = "in " + distanceString
            image = UIImage(named: "banner_icon_turn_right.png")
        case NTRoutingAction.ROUTING_ACTION_UTURN:
            message = "Make a U-Turn in " + distanceString
        case NTRoutingAction.ROUTING_ACTION_START_AT_END_OF_STREET:

            if (next != nil) {
            let nextAction = next!.getAction()
            
                switch (nextAction) {
                case NTRoutingAction.ROUTING_ACTION_TURN_LEFT:
                    message = "in " + distanceString
                    image = UIImage(named: "banner_icon_turn_left.png")
                case NTRoutingAction.ROUTING_ACTION_TURN_RIGHT:
                    message = "in " + distanceString
                    image = UIImage(named: "banner_icon_turn_right.png")
                case NTRoutingAction.ROUTING_ACTION_FINISH:
                    message = "You'll arrive at your destination in " + distanceString
                    image = UIImage(named: "icon_banner_finish.png")
                default:
                    break
                }
            }
            
        default:
            break
        }
        
        DispatchQueue.main.async {
            self.instructionLabel.text = message.uppercased()
            self.imageView.image = image
            self.show()
        }
    }
    
    func updateRouteInfo(result: NTRoutingResult) {
        let rawDistance = result.getTotalDistance()
        let rawTime = result.getTotalTime()
        
        let parsedDistance = NSMutableAttributedString()
        let parsedTime = NSMutableAttributedString()
        
        let km = 1000.0
        let minute = 60.0
        let hour = 60.0 * minute
        
        if (rawDistance > km) {
            // Use different unit of measurement if it's greater than one kilometer
            
            let kilometers = round(rawDistance / km)
            let meters = round(rawDistance.truncatingRemainder(dividingBy: km))
            
            parsedDistance.bold(Int(kilometers).description)
            parsedDistance.normal(" km ".uppercased())
            
            parsedDistance.bold(Int(meters).description)
            parsedDistance.normal(" m".uppercased())
            
        } else {
            
            parsedDistance.bold(Int(round(rawDistance)).description)
            parsedDistance.normal(" meters".uppercased())
        }
        
        parsedDistance.normal(" to destination".uppercased())
        
        parsedTime.normal("You'll arrive in ".uppercased())
        
        if (rawTime > hour) {
            // Use different unit of measurement if it's greater than one hour
            
            let hours = round(rawTime / hour)
            let minutes = round((rawTime / minute).truncatingRemainder(dividingBy: minute))
            
            parsedTime.bold(Int(hours).description)
            parsedTime.normal(" hours and ".uppercased())
            
            parsedTime.bold(Int(minutes).description)
            parsedTime.normal(" minutes".uppercased())
        } else {
            let minutes = round(rawTime / minute)
            parsedTime.bold(Int(minutes).description)
            parsedTime.normal(" minutes".uppercased())
        }
        
        DispatchQueue.main.async {
            self.routeDistanceInfoLabel.attributedText = parsedDistance
            self.routeTimeInfoLabel.attributedText = parsedTime
            self.show()
        }
    }
    
    var visibleY: CGFloat = 0
    var hiddenY: CGFloat = 0
    
    func show() {
        UIView.animate(withDuration: 0.4, animations: {
            self.frame = CGRect(x: self.frame.origin.x, y:  self.visibleY, width:  self.frame.width, height:  self.frame.height)
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.2, animations: {
            self.frame = CGRect(x:  self.frame.origin.x, y:  self.hiddenY, width:  self.frame.width, height:  self.frame.height)
        })
    }
    
}
