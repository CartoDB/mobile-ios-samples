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
        
        
        contentView.setOnlineMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        client.onResume()
        client.delegate = self
        
        (contentView as! TurnByTurnView).startButton.delegate = self
        
        let text = "Download the region and long click on the map \n to set your navigation destination"
        contentView.banner.showInformation(text: text, autoclose: true)
        
        (self.contentView as! TurnByTurnView).modeContent.table.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        client.onPause()
        client.delegate = nil
        
        (contentView as! TurnByTurnView).startButton.delegate = nil
        
        (self.contentView as! TurnByTurnView).modeContent.table.delegate = nil
    }
    
    func mapMoved() {
        
        if (!client.isInNavigationMode) {
            // We only need to listen to map moved events when in navigation mode,
            // as moving will pause navigation mode
            return
        }
        
        if (!(contentView.map as! MapWithTouchEvents).isTouchInProgress) {
            // Only pause if it's a user is manually moving the map,
            // NTMapEventListener's onMapMoved is also called on animations
            return
        }
        
        client.isPaused = true
        (contentView as! TurnByTurnView).startButton.pause()
    }
    
    override func switchChanged() {
        
        if (contentView as! TurnByTurnView).startButton.isPaused {
            client.resumeNavigationMode()
        } else {
            let value = (contentView as! TurnByTurnView).startButton.isStopped
            client.startNavigationMode(start: value)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let modeContent = (self.contentView as! TurnByTurnView).modeContent
        
        if tableView == modeContent.table {
            let cell = modeContent.highlightRow(at: indexPath)
            client.routing.updateMode(mode: cell.mode!.mode)
        } else {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
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
    
    func instructionFound(current: NTRoutingInstruction, next: NTRoutingInstruction?) {
        (contentView as! TurnByTurnView).turnByTurnBanner.updateInstruction(current: current, next: next)
        contentView.banner.hide()
    }
    
    func locationUpdated(result: NTRoutingResult) {
        (contentView as! TurnByTurnView).turnByTurnBanner.updateRouteInfo(result: result)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}








