//
//  GeocodingResultCell.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 14/09/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class GeocodingResultCell: UITableViewCell {
    
    var title: UILabel!
    var subtitle: UILabel!
    
    let leftPadding: CGFloat = 15
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.lightTransparentGray
        
        selectionStyle = .none
        
        title = UILabel()
        title.textColor = UIColor.white
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        addSubview(title)
        
        subtitle = UILabel()
        subtitle.textColor = Colors.nearWhite
        subtitle.font = UIFont(name: "HelveticaNeue", size: 11)
        addSubview(subtitle)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        title.sizeToFit()
        subtitle.sizeToFit()
    
        let topPadding: CGFloat = (frame.height - (title.frame.height + subtitle.frame.height)) / 2
        
        let titleWidth: CGFloat = frame.width - 2 * leftPadding
        
        let x: CGFloat = leftPadding
        var y: CGFloat = topPadding
        let w: CGFloat = titleWidth
        let h: CGFloat = title.frame.height
        
        title.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h
        
        subtitle.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func update(result : NTGeocodingResult) {
        self.title.text = result.getPrettyAddress()
        self.subtitle.text = result.getType()
    }
}
