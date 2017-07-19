//
//  CityPopupContent.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class CityPopupContent : UIView, UITableViewDataSource {
    
    let IDENTIFIER = "CityCell"
    
    var table: UITableView!
    
    var cities: [City] = [City]()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        table = UITableView()
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: IDENTIFIER)
        
        addSubview(table)
    }
    
    override func layoutSubviews() {
        table.frame = bounds
    }
    
    func addCities(cities: [City]) {
        self.cities = cities
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let city = cities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER, for: indexPath as IndexPath)
        cell.selectionStyle = .none
        
        cell.textLabel!.font = UIFont(name: "Helvetica-Bold", size: 12)
        
        var text = cities[indexPath.row].name.uppercased()

        if (city.size > 0.0) {
            cell.textLabel!.textColor = Colors.appleBlue
            text += " (" + String(describing: city.size!) + " MB)"
        } else {
            cell.textLabel!.textColor = UIColor.lightGray
        }
        
        cell.textLabel!.text = text
        
        return cell
    }
    
    func update(id: String, size: Double) {
        let found = cities.first(where: { $0.boundingBox.toString() == id })
        if (found != nil) {
            found?.size = size
            self.table.reloadData()
        }
    }
}
