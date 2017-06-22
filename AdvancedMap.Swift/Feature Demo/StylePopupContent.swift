//
//  StylePopupContent.swift
//  Feature Demo
//
//  Created by Aare Undo on 20/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class StylePopupContent : UIScrollView {
    
    static let NutiteqSource = "nutiteq.osm"
    static let MapzenSource = "mapzen.osm"
    static let CartoSource = "carto.osm"
    
    static let Bright = "BRIGHT"
    static let Gray = "GRAY"
    static let Dark = "DARK"
    
    static let Positron = "POSITRON"
    static let DarkMatter = "DARKMATTER"
    
    static let PositronUrl = "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png";
    static let DarkMatterUrl = "http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png";
    
    var nutiteq: StylePopupContentSection!
    var mapzen: StylePopupContentSection!
    var carto: StylePopupContentSection!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        nutiteq = StylePopupContentSection()
        nutiteq.setSource(source: StylePopupContent.NutiteqSource)
        nutiteq.addItem(text: StylePopupContent.Bright, imageUrl: "style_image_nutiteq_bright.png")
        nutiteq.addItem(text: StylePopupContent.Gray, imageUrl: "style_image_nutiteq_gray.png")
        nutiteq.addItem(text: StylePopupContent.Dark, imageUrl: "style_image_nutiteq_dark.png")
        
        addSubview(nutiteq)
        
        mapzen = StylePopupContentSection()
        mapzen.setSource(source: StylePopupContent.MapzenSource)
        mapzen.addItem(text: StylePopupContent.Bright, imageUrl: "style_image_mapzen_bright.png")
        mapzen.addItem(text: StylePopupContent.Positron, imageUrl: "style_image_mapzen_positron.png")
        mapzen.addItem(text: StylePopupContent.DarkMatter, imageUrl: "style_image_mapzen_darkmatter.png")
        
        addSubview(mapzen)
        
        carto = StylePopupContentSection()
        carto.setSource(source: StylePopupContent.CartoSource)
        carto.addItem(text: StylePopupContent.Positron, imageUrl: "style_image_carto_positron.png")
        carto.addItem(text: StylePopupContent.DarkMatter, imageUrl: "style_image_carto_darkmatter.png")
        
        addSubview(carto)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let max: CGFloat = 90
        let padding: CGFloat = 5
        let headerPadding: CGFloat = 20
        
        let x: CGFloat = padding
        var y: CGFloat = 0
        let w: CGFloat = frame.width - 2 * padding
        var h: CGFloat = (frame.height - 2 * headerPadding) / 3
        
        if (h > max) {
            h = max
        }
        
        nutiteq.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h + headerPadding
        
        mapzen.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h + headerPadding
        
        carto.frame = CGRect(x: x, y: y, width: w, height: h)
        
        contentSize = CGSize(width: frame.width, height: y + h + padding)
    }
    
}

class StylePopupContentSection : UIView {
    
    var header: UILabel!
    var separator: UIView!
    
    var list = [StylePopupContentSectionItem]()
    
    var delegate: StyleUpdateDelegate!
    
    var source: String!
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        header = UILabel()
        header.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        header.textColor = Colors.navy
        addSubview(header)
        
        separator = UIView()
        separator.backgroundColor = Colors.nearWhite
        separator.clipsToBounds = false
        
        addSubview(separator)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.itemTapped(_:)))
        addGestureRecognizer(recognizer)
    }
    
    override func layoutSubviews() {
        
        let headerHeight: CGFloat = 20
        let padding: CGFloat = 5
        
        separator.frame = CGRect(x: padding, y: -padding, width: frame.width - 2 * padding, height: 1)
        
        var x: CGFloat = padding
        var y: CGFloat = 0
        var w: CGFloat = frame.width - 3 * padding
        var h: CGFloat = headerHeight
        
        header.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y = headerHeight
        w = (frame.width - 4 * padding) / 3
        h = frame.height - 2 * padding
        
        for item in list {
            item.frame = CGRect(x: x, y: y, width: w, height: h)
            
            x += w + padding
        }
    }
    
    func itemTapped(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self)
        
        for item in list {
            if (item.frame.contains(location)) {
                delegate?.styleClicked(selection: item.label.text!, source: source)
            }
        }
    }
    
    func setSource(source: String) {
        
        self.source = source
        
        let text = source.replacingOccurrences(of: ".osm", with: "").uppercased()
        header.text = text
    }
    
    func addItem(text: String, imageUrl: String) {
        let item = StylePopupContentSectionItem(text: text, imageUrl: imageUrl)
        
        list.append(item)
        addSubview(item)
    }
}

class StylePopupContentSectionItem : UIView {
    
    var imageView: UIImageView!
    var label: UILabel!
    
    convenience init(text: String, imageUrl: String) {
        self.init(frame: CGRect.zero)
        
        imageView = UIImageView()
        imageView.image = UIImage(named: imageUrl)
        imageView.contentMode = .scaleToFill
        
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
}

protocol StyleUpdateDelegate {
    
    func styleClicked(selection: String, source: String)
}










