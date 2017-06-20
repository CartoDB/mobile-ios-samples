//
//  LanguagePopupContent.swift
//  Feature Demo
//
//  Created by Aare Undo on 20/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class LanguagePopupContent : UIView, UITableViewDataSource {
    
    var table: UITableView!
    
    var languages: [Language] = [Language]()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        table = UITableView()
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "LanguageCell")
        addSubview(table)
    }
    
    override func layoutSubviews() {
        table.frame = bounds
    }
    
    func addLanguages(languages: [Language]) {
        self.languages = languages
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath as IndexPath)
        cell.textLabel!.text = languages[indexPath.row].name
        
        return cell
    }
}

class LanguageCell : UITableViewCell {
    
}
