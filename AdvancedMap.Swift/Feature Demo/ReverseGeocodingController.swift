//
//  ReverseGeocodingController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 06/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class ReverseGecodingController : BaseGeocodingController, ReverseGeocodingEventDelegate {
    
    var geocodingListener: ReverseGeocodingEventListener!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = ReverseGeocodingView()
        view = contentView
        
        geocodingListener = ReverseGeocodingEventListener()
        geocodingListener.projection = contentView.projection
        
        let folder = Utils.createDirectory(name: BaseGeocodingView.PACKAGE_FOLDER)
        contentView.manager = NTCartoPackageManager(source: BaseGeocodingView.SOURCE, dataFolder: folder)
        
        setOnlineMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        geocodingListener.delegate = self

        contentView.map.setMapEventListener(geocodingListener)
        
        let text = "Click on the map to find out more about a location"
        contentView.banner.showInformation(text: text, autoclose: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        geocodingListener.delegate = nil
        
        contentView.map.setMapEventListener(nil)
    }
    
    func foundResult(result: NTGeocodingResult!) {

        if (result == nil) {
            alert(message: "Couldn't find any addresses. Are you sure you have downloaded the region you're trying to reverse geocode?")
            return
        }
        
        let title = ""
        let description = result.description()!

        let goToPosition = false
        
        (contentView as! ReverseGeocodingView).showResult(result: result, title: title, description: description, goToPosition: goToPosition)
    }
    
    override func setOnlineMode() {
        super.setOnlineMode()
        geocodingListener.service = NTPeliasOnlineReverseGeocodingService(apiKey: BaseGeocodingController.API_KEY)
    }
    
    override func setOfflineMode() {
        super.setOfflineMode()
        geocodingListener.service = NTPackageManagerReverseGeocodingService(packageManager: contentView.manager)
    }
}








