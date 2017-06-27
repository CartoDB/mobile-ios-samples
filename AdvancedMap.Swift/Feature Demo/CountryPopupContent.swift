//
//  CountryDownloadContent.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

class CountryPopupContent : UIView, UITableViewDataSource {
    
    let IDENTIFIER = "CountryCell"
    
    var table: UITableView!
    
    var countries: [Country] = [Country]()
    
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
    
    func addCountries(countries: [Country]) {
        self.countries = countries
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER, for: indexPath as IndexPath)
        cell.textLabel!.text = countries[indexPath.row].name
        
        return cell
    }
}
