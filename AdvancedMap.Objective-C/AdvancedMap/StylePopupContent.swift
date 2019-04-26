//
//  StylePopupContent.swift
//  Feature Demo
//
//  Created by Aare Undo on 20/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

@objc class StylePopupContent : UIScrollView {
    
    @objc static let CartoVectorSource = "carto.streets"
    @objc static let CartoRasterSource = "carto.osm"
    
    @objc static let Bright = "BRIGHT"
    @objc static let Gray = "GRAY"
    @objc static let Dark = "DARK"
    
    @objc static let Positron = "POSITRON"
    @objc static let DarkMatter = "DARKMATTER"
    @objc static let Voyager = "VOYAGER"
    
    @objc static let VoyagerUrl = "http://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png";
    @objc static let PositronUrl = "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png";
    @objc static let DarkMatterUrl = "http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png";
    
    @objc var cartoVector: StylePopupContentSection!
    @objc var cartoRaster: StylePopupContentSection!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        cartoVector = StylePopupContentSection()
        cartoVector.source = StylePopupContent.CartoVectorSource
        cartoVector.header.text = "CARTO VECTOR"
        cartoVector.addItem(text: StylePopupContent.Voyager, imageUrl: "style_image_nutiteq_voyager.png")
        cartoVector.addItem(text: StylePopupContent.Positron, imageUrl: "style_image_nutiteq_positron.png")
        cartoVector.addItem(text: StylePopupContent.DarkMatter, imageUrl: "style_image_nutiteq_darkmatter.png")
        
        addSubview(cartoVector)
        
        cartoRaster = StylePopupContentSection()
        cartoRaster.source = StylePopupContent.CartoRasterSource
        cartoRaster.header.text = "CARTO RASTER"
        cartoRaster.addItem(text: StylePopupContent.Voyager, imageUrl: "style_image_carto_voyager.png")
        cartoRaster.addItem(text: StylePopupContent.Positron, imageUrl: "style_image_carto_positron.png")
        cartoRaster.addItem(text: StylePopupContent.DarkMatter, imageUrl: "style_image_carto_darkmatter.png")
        
        addSubview(cartoRaster)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 5
        let headerPadding: CGFloat = 20
        
        let x: CGFloat = padding
        var y: CGFloat = 0
        let w: CGFloat = frame.width - 2 * padding
        var h: CGFloat = cartoVector.getHeight()
        
        cartoVector.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h + headerPadding
        h = cartoRaster.getHeight()
        cartoRaster.frame = CGRect(x: x, y: y, width: w, height: h)
        
        contentSize = CGSize(width: frame.width, height: y + h + padding)
    }
    
    @objc func highlightDefault() {
        getDefault().highlight()
    }
    
    @objc func normalizeDefaultHighlight() {
        getDefault().normalize()
    }
    
    @objc func getDefault() -> StylePopupContentSectionItem {
        return cartoVector.list[0]
    }
    
}

@objc class StylePopupContentSection : UIView {
    
    @objc var header: UILabel!
    @objc var separator: UIView!
    
    @objc var list = [StylePopupContentSectionItem]()
    
    @objc var delegate: StyleUpdateDelegate!
    
    @objc var source: String!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        header = UILabel()
        header.font = UIFont(name: "Helvetica-Bold", size: 13)
        header.textColor = Colors.navy
        addSubview(header)
        
        separator = UIView()
        separator.backgroundColor = Colors.fromRgba(red: 220, green: 220, blue: 220, alpha: 200)
        separator.clipsToBounds = false
        
        addSubview(separator)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.itemTapped(_:)))
        addGestureRecognizer(recognizer)
    }
    
    let headerHeight: CGFloat = 40
    let padding: CGFloat = 5
    
    override func layoutSubviews() {

        separator.frame = CGRect(x: padding, y: -padding, width: frame.width - 2 * padding, height: 1)
        
        var x: CGFloat = padding
        var y: CGFloat = 0
        var w: CGFloat = frame.width - 3 * padding
        var h: CGFloat = headerHeight
        
        header.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y = headerHeight
        w = (frame.width - 4 * padding) / 3
        h = rowHeight - 2 * padding
        
        for item in list {
            item.frame = CGRect(x: x, y: y, width: w, height: h)
            
            x += w + padding
            
            if (x == frame.width) {
                x = padding
                y += rowHeight
            }
        }
    }
    
    let rowHeight: CGFloat = 110
    
    @objc func getHeight() -> CGFloat {
        
        let extra = headerHeight - CGFloat(Int(list.count / 3 * 2) * Int(padding))
        
        if (list.count > 6) {
            return 3 * rowHeight + extra
        }
        
        if (list.count > 3) {
            return 2 * rowHeight + extra
        }
        
        return rowHeight + extra
    }
    
    @objc func itemTapped(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self)
        
        for item in list {
            if (item.frame.contains(location)) {
                
                delegate?.styleClicked(selection: item, source: source)
            }
        }
    }

    func addItem(text: String, imageUrl: String) {
        let item = StylePopupContentSectionItem(text: text, imageUrl: imageUrl)
        
        list.append(item)
        addSubview(item)
    }
}

@objc class StylePopupContentSectionItem : UIView {
    
    @objc var imageView: UIImageView!
    @objc var label: UILabel!
    
    convenience init(text: String, imageUrl: String) {
        self.init(frame: CGRect.zero)
        
        imageView = UIImageView()
        imageView.image = UIImage(named: imageUrl)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = Colors.appleBlue.cgColor
        addSubview(imageView)
        
        label = UILabel()
        label.text = text
        label.textColor = Colors.appleBlue
        label.font = UIFont(name: "HelveticaNeue", size: 11)
        addSubview(label)
    }
    
    override func layoutSubviews() {
        
        let padding: CGFloat = 5
        
        let x: CGFloat = 0
        var y: CGFloat = 0
        let w: CGFloat = frame.width
        var h: CGFloat = frame.height / 3 * 2
        
        imageView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        label.sizeToFit()
        
        y += h + padding
        h = label.frame.height
        
        label.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    @objc func highlight() {
        imageView.layer.borderWidth = 3
    }
    
    @objc func normalize() {
        imageView.layer.borderWidth = 0
    }
}

@objc protocol StyleUpdateDelegate {
    
    func styleClicked(selection: StylePopupContentSectionItem, source: String)
}










