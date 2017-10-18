//
//  TurnByTurnController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 09/10/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import CoreLocation

class TurnByTurnController: BasePackageDownloadController, NextTurnDelegate {
    
    var client: TurnByTurnClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = TurnByTurnView()
        view = contentView
        
        client = TurnByTurnClient(mapView: contentView.map)
        
        let source = Routing.ROUTING_TAG + Routing.OFFLINE_ROUTING_SOURCE
        let folder = Utils.createDirectory(name: PackageDownloadBaseView.ROUTING_FOLDER)
        contentView.manager = NTCartoPackageManager(source: source, dataFolder: folder)
        
        client.routing.service = NTPackageManagerValhallaRoutingService(packageManager: contentView.manager)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        client.onResume()
        client.delegate = self
        
        let text = "Long click on the map to set a destination"
        contentView.banner.showInformation(text: text, autoclose: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        client.onPause()
        client.delegate = nil
    }
    
    override func downloadComplete(sender: PackageListener, id: String) {
        DispatchQueue.main.async {
            self.contentView.banner.showInformation(text: "Download complete!", autoclose: true)
        }
    }
    
    func routingFailed() {
        let text = "Routing failed. Are you sure you've downloaded the correct package?"
        DispatchQueue.main.async {
            self.contentView.banner.showInformation(text: text, autoclose: true)
        }
    }
    
    func instructionFound(instruction: NTRoutingInstruction) {
        
        let action = instruction.getAction()
        let distance = instruction.getDistance()
        
        let distanceString = String(describing: distance) + " meters"
        
        var message = ""
        
        // There are actually even more RoutingActions, but I've covered the most prominent ones
        switch (action) {
        case NTRoutingAction.ROUTING_ACTION_ENTER_ROUNDABOUT:
            message = "Enter Roundabout in " + distanceString + " meters"
        case NTRoutingAction.ROUTING_ACTION_FINISH:
            message = "You'll arrive at your destination in " + distanceString + " meters"
        case NTRoutingAction.ROUTING_ACTION_GO_STRAIGHT:
            message = "Go straight for " + distanceString + " meters"
        case NTRoutingAction.ROUTING_ACTION_LEAVE_ROUNDABOUT:
            message = "Leave roundabout in " + distanceString + " meters"
        case NTRoutingAction.ROUTING_ACTION_STAY_ON_ROUNDABOUT:
            message = "Stay on roundabout for " + distanceString + " meters"
        case NTRoutingAction.ROUTING_ACTION_TURN_LEFT:
            message = "Turn left in " + distanceString + " meters"
        case NTRoutingAction.ROUTING_ACTION_TURN_RIGHT:
            message = "Turn right in " + distanceString + " meters"
        case NTRoutingAction.ROUTING_ACTION_UTURN:
            message = "Make a U-Turn in " + distanceString + " meters"
        case NTRoutingAction.ROUTING_ACTION_START_AT_END_OF_STREET:
            message = "Start at the end of the street"
        default:
            break
        }
        
        DispatchQueue.main.async {
            self.contentView.banner.showInformation(text: message, autoclose: false)
        }
        
    }
}



