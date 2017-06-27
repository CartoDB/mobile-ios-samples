//
//  CityDownloadController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class CityDownloadController : BaseController, UITableViewDelegate {
    
    var contentView: CityDownloadView!
    
    override func viewDidLoad() {
        
        contentView = CityDownloadView()
        view = contentView
        
        contentView.cityContent.addCities(cities: Cities.list)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        contentView.cityContent.table.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        contentView.cityContent.table.delegate = nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = contentView.cityContent.cities[indexPath.row]
        contentView.popup.hide()
    }
}
