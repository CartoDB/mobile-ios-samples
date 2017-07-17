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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER, for: indexPath as IndexPath)
        cell.textLabel!.text = cities[indexPath.row].name
        
        return cell
    }
}
