//
//  LauncherListController.swift
//  CartoMap.Swift
//
//  Created by Aare Undo on 27/10/16.
//  Copyright © 2016 Aare Undo. All rights reserved.
//

import Foundation

class LauncherListController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var IDENTIFIER = "cell";
    
    var samples = [ DotsVisController(), CountriesVisController(), FontsVisController() ];
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        let table = UITableView(frame: UIScreen.main.bounds);
        
        table.delegate = self;
        table.dataSource = self;
        
        self.view = table;
        
        table.register(TableCell.self, forCellReuseIdentifier: IDENTIFIER);
        
        table.reloadData();
        
        title = "CARTO Map";
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.samples.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = samples[indexPath.row];
        navigationController?.pushViewController(controller, animated: true);
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER) as! TableCell;
        
        let sample = samples[indexPath.row];

        cell.nameLabel?.text = sample.getName();
        cell.descriptionLabel?.text = sample.getDescription();
        
        return cell;
    }
}

class TableCell : UITableViewCell
{
    var nameLabel: UILabel!;
    var descriptionLabel: UILabel!;
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        
        self.nameLabel = UILabel();
        self.nameLabel.font = UIFont(name: "Helvetica Neue", size: 18);
        addSubview(self.nameLabel);
        
        self.descriptionLabel = UILabel();
        self.descriptionLabel.textColor = UIColor.darkGray;
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.font = UIFont(name: "Helvetica Neue", size: 14);
        addSubview(self.descriptionLabel);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews();
        
        let padding:CGFloat = 10;
        
        let x:CGFloat = padding;
        var y:CGFloat = 0.0;
        let w:CGFloat = frame.width - 2 * padding;
        let h:CGFloat = frame.height / 2;

        nameLabel.frame = CGRect(x: x, y: y, width: w, height: h);

        y += h;

        descriptionLabel.frame = CGRect(x: x, y: y, width: w, height: h);
    }
}










