//
//  CountryDownloadContent.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

class PackagePopupContent : UIView, UITableViewDataSource {
    
    let IDENTIFIER = "CountryCell"
    
    var table: UITableView!
    
    var packages: [Package] = [Package]()
    
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
    
    func addPackages(packages: [Package]) {
        self.packages = packages
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER, for: indexPath as IndexPath)
        cell.textLabel!.text = packages[indexPath.row].name
        
        return cell
    }
}
