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
}

class PackageCell : UITableViewCell {
    
    var package: Package!
    
    var title: UILabel!
    var subtitle: UILabel!
    var statusIndicator: UILabel!
    var forwardIcon: UIImageView!
    
    var progressIndicator: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 13)
        let titleColor = Colors.navy
        
        textLabel?.font = titleFont
        textLabel?.textColor = titleColor
        
        title = UILabel()
        title.textColor = titleColor
        title.font = titleFont
        addSubview(title)
        
        subtitle = UILabel()
        subtitle.textColor = UIColor.lightGray
        subtitle.font = UIFont(name: "HelveticaNeue", size: 11)
        addSubview(subtitle)
        
        statusIndicator = UILabel()
        statusIndicator.textAlignment = .center
        statusIndicator.textColor = Colors.appleBlue
        statusIndicator.font = UIFont(name: "HelveticaNeue-Bold", size: 11)
        statusIndicator.layer.cornerRadius = 5
        statusIndicator.layer.borderColor = statusIndicator.textColor.cgColor
        addSubview(statusIndicator)
        
        forwardIcon = UIImageView()
        forwardIcon.image = UIImage(named: "icon_forward_blue.png")
        addSubview(forwardIcon)
        
        progressIndicator = UIView()
        addSubview(progressIndicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let leftPadding: CGFloat = 15
        
        if (package.isGroup()) {
            title.frame = CGRect.zero
            subtitle.frame = CGRect.zero
            statusIndicator.frame = CGRect.zero
            progressIndicator.frame = CGRect.zero
            
            let h: CGFloat = frame.height / 3
            let w: CGFloat = h / 2
            let x: CGFloat = frame.width - (w + leftPadding)
            let y: CGFloat = frame.height / 2 - h / 2
            
            forwardIcon.frame = CGRect(x: x, y: y, width: w, height: h)

            return
        }
        
        title.sizeToFit()
        subtitle.sizeToFit()
        statusIndicator.sizeToFit()
        
        let topPadding: CGFloat = (frame.height - (title.frame.height + subtitle.frame.height)) / 2
        
        let titleWidth: CGFloat = frame.width * 0.66
        
        var x: CGFloat = leftPadding
        var y: CGFloat = topPadding
        var w: CGFloat = titleWidth
        var h: CGFloat = title.frame.height
        
        title.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h
        
        subtitle.frame = CGRect(x: x, y: y, width: w, height: h)
        
        w = 82
        h = frame.height / 3 * 2
        x = frame.width - (w + leftPadding)
        y = frame.height / 2 - h / 2
        
        statusIndicator.frame = CGRect(x: x, y: y, width: w, height: h)
        
        w = frame.width - 2 * leftPadding
        h = 1
        x = leftPadding
        y = frame.height - (h + topPadding)
        
        progressIndicator.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(package: Package) {
        
        self.package = package
        
        if (package.isGroup()) {
            // It's a package group. These are displayed with a single label
            textLabel?.text = package.name.uppercased()
            forwardIcon.isHidden = false
            return
        }
        
        forwardIcon.isHidden = true
        
        // "Hide" the original label, as these aren't used in advanced cells
        textLabel?.text = ""
        
        title.text = package.name.uppercased()
        subtitle.text = package.getStatusText()
        
        let action = package.getActionText()
        statusIndicator.text = action
        
        if (action == Package.ACTION_DOWNLOAD) {
            statusIndicator.layer.borderWidth = 1
        } else {
            statusIndicator.layer.borderWidth = 0
        }
    }
}









