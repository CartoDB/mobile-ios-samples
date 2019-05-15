//
//  MapOptionsPopupContent.swift
//  Feature Demo
//
//  Created by Aare Undo on 20/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

@objc class MapOptionsPopupContent : UIView, UITableViewDataSource, UITableViewDelegate {
    
    @objc var table: UITableView!

    var mapOptions: [MapOption] = [MapOption]()

    @objc var delegate: MapOptionsUpdateDelegate!

    convenience init() {
        self.init(frame: CGRect.zero)
        
        table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "MapOptionsCell")
        addSubview(table)
    }
    
    override func layoutSubviews() {
        table.frame = bounds
    }
    
    @objc func addOptions(mapOptions: [MapOption]) {
        self.mapOptions = mapOptions
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = mapOptions[indexPath.row].tag
        mapOptions[indexPath.row].value = !mapOptions[indexPath.row].value
        table.reloadData()
        
        delegate?.optionClicked(option: option!, turnOn: mapOptions[indexPath.row].value)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapOptionsCell", for: indexPath as IndexPath)
        cell.textLabel!.text = mapOptions[indexPath.row].name
        cell.tag = indexPath.row
        cell.accessoryType = mapOptions[indexPath.row].value ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        
        return cell
    }
}

@objc class MapOptionsCell : UITableViewCell {
    
}

@objc protocol MapOptionsUpdateDelegate {
    
    func optionClicked(option: String, turnOn: Bool)
}
