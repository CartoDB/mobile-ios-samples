//
//  ReverseGeocodingController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 06/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class ReverseGecodingController : BaseController, ReverseGeocodingEventDelegate {
    
    var contentView: ReverseGeocodingView!
    
    var listener: ReverseGeocodingEventListener!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = ReverseGeocodingView()
        view = contentView
        
        listener = ReverseGeocodingEventListener()
        listener.projection = contentView.projection
        
        let path = Bundle.main.path(forResource: "estonia-latest", ofType: "sqlite")
        listener.service = NTOSMOfflineReverseGeocodingService(path: path)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        
        listener.delegate = self
        
        contentView.map.setMapEventListener(listener)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        listener.delegate = nil
        
        contentView.map.setMapEventListener(nil)
    }
    
    func foundResult(result: NTGeocodingResult!) {

        let title = ""
        var description = "No address found"
        
        if (result != nil) {
            description = result.description()
        }
        
        let goToPosition = false
        
        contentView.showResult(result: result, title: title, description: description, goToPosition: goToPosition)
    }
}
        







