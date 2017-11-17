//
//  TransportModePopupContent.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 17/11/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class TransportModePopupContent: UIView, UITableViewDataSource {
    
    let IDENTIFIER = "TransportModeCell"
    
    var table: UITableView!
    
    var modes: [TransportMode] = [TransportMode]()
    
    init() {
        super.init(frame: CGRect.zero)
        
        var mode = TransportMode(title: "Pedestrian", description: "Standard walking route that excludes roads without pedestrian access, walkways and footpaths are slightly favored", mode: "pedestrian")
        modes.append(mode)
        
        mode = TransportMode(title: "Car", description: "Standard costing for driving routes by car, motorcycle, truck, and so on that obeys automobile driving rules, such as access and turn restrictions. ", mode: "auto")
        modes.append(mode)
        
        mode = TransportMode(title: "Bicycle", description: "Standard costing for travel by bicycle, with a slight preference for using cycleways or roads with bicycle lanes.", mode: "bicycle")
        modes.append(mode)
        
        mode = TransportMode(title: "MultiModal", description: "Pedestrian and transit. In the future, multimodal will support a combination of all of the above.", mode: "multimodal")
        modes.append(mode)
        
        table = UITableView()
        table.dataSource = self
        table.register(TransportModeCell.self, forCellReuseIdentifier: IDENTIFIER)
        table.rowHeight = 70
        addSubview(table)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        table.frame = bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modes.count
    }
    
    var initialHighlightSet = false
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mode = modes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER, for: indexPath as IndexPath) as! TransportModeCell
        cell.selectionStyle = .none
        cell.update(mode: mode)
        
        if (!initialHighlightSet && cell.mode?.mode == "pedestrian") {
            initialHighlightSet = true
            cell.activate()
        }
        return cell
    }
    
    var previous: TransportModeCell?
    
    func highlightRow(at: IndexPath) -> TransportModeCell {
        
        for cell in table.visibleCells {
            (cell as! TransportModeCell).normalize()
        }
        
        let cell = table.cellForRow(at: at) as! TransportModeCell
        cell.activate()
        return cell
    }
}

class TransportModeCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let checkMark = UIImageView()
    
    var mode: TransportMode?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        titleLabel.textColor = UIColor.darkGray
        addSubview(titleLabel)
        
        descriptionLabel.font = UIFont(name: "HelveticaNeue", size: 11)
        descriptionLabel.textColor = UIColor.lightGray
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0;
        addSubview(descriptionLabel)
        
        checkMark.image = UIImage(named: "icon_checkmark_green.png")
        addSubview(checkMark)
        
        normalize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 5
        
        let x = padding
        var y = padding
        let w = frame.width - 2 * padding
        let h = (frame.height - 2 * padding) / 2
        
        titleLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        let checkHeight = h / 1.3
        checkMark.frame = CGRect(x: frame.width - (checkHeight + padding), y: y, width: checkHeight, height: checkHeight * 1.27)
        
        y += h
        
        descriptionLabel.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func update(mode: TransportMode) {
        self.mode = mode
        titleLabel.text = mode.title
        descriptionLabel.text = mode.description
    }
    
    func activate() {
        checkMark.isHidden = false
    }
    
    func normalize() {
        checkMark.isHidden = true
    }
}

class TransportMode {
    
    var title = ""
    var description = ""
    
    var mode = ""
    
    init(title: String, description: String, mode: String) {
        self.title = title
        self.description = description
        self.mode = mode
    }
}






