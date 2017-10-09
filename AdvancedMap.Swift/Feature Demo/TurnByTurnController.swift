//
//  TurnByTurnController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 09/10/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import CoreLocation

class TurnByTurnController: BaseController {
    
    let contentView = TurnByTurnView()

    var client: TurnByTurnClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = contentView
        
        client = TurnByTurnClient(mapView: contentView.map)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        
        client.onResume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()

        client.onPause()
    }
}
