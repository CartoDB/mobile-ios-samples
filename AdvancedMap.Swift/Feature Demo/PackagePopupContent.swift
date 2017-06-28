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
        table.register(PackageCell.self, forCellReuseIdentifier: IDENTIFIER)

        addSubview(table)
    }
    
    override func layoutSubviews() {
        table.frame = bounds
    }
    
    func addPackages(packages: [Package]) {
        self.packages = packages
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER, for: indexPath as IndexPath) as? PackageCell
        
        let package = packages[indexPath.row]
        cell?.update(package: package)
        
        return cell!
    }
    
    func findAndUpdate(package: Package, progress: CGFloat) {
        find(package: package)?.update(package: package, progress: progress)
    }
    
    func findAndUpdate(package: Package) {
        find(package: package)?.update(package: package)
    }
    
    func find(package: Package) -> PackageCell? {
        for cell in table.visibleCells {
            let packageCell = cell as? PackageCell
            
            if (packageCell?.package.id == package.id) {
                return packageCell
            }
        }
        
        return nil
    }
    
}










