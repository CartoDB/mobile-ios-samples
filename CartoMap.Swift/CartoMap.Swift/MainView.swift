//
//  MainView.swift
//  Feature Demo
//
//  Created by Aare Undo on 16/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class MainView: UIScrollView {
    
    weak var galleryDelegate: GalleryDelegate?
    
    var views: [GalleryRow] = [GalleryRow]()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        backgroundColor = Colors.fromRgba(red: 250, green: 250, blue: 250, alpha: 255)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        addGestureRecognizer(recognizer)
    }
    
    func tapped(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self)
        
        for view in views {
            if (view.frame.contains(location)) {
                galleryDelegate?.galleryItemClick(item: view)
            }
        }
    }
    
    override func layoutSubviews() {
        
        var itemsInRow: CGFloat = 2
        
        if (frame.width > frame.height) {
            itemsInRow = 3
            
            if (frame.width > 1000) {
                itemsInRow = 4
            }
        } else if (frame.width > 700) {
            itemsInRow = 3
        }
        
        let padding: CGFloat = 5
        var counter: CGFloat = 0
        
        var x = padding
        var y = padding
        let w = (frame.width - (itemsInRow + 1) * padding) / itemsInRow
        let h = w
        
        for view in views {
            
            let xWithoutPadding = (counter.truncatingRemainder(dividingBy: itemsInRow) * w)
            let multipliedXPadding = ((counter.truncatingRemainder(dividingBy: itemsInRow) + 1) * padding)
            
            x = xWithoutPadding + multipliedXPadding
            
            let yWithoutPadding = h * ((CGFloat)((Int)(counter / itemsInRow)))
            let multipliedYPadding = padding * ((CGFloat)((Int)(counter / itemsInRow))) + padding
            
            y = yWithoutPadding + multipliedYPadding
            
            view.frame = CGRect(x: x, y: y, width: w, height: h)
            
            counter += 1;
            
            if (Int(counter) == views.count) {
                contentSize = CGSize(width: frame.width, height: y + h + padding)
            }
        }
    }
    
    func addRows(rows: [Sample]) {
        
        views.removeAll()
        
        for view in subviews {
            
            if let row = view as? GalleryRow {
                row.removeFromSuperview()
            }
        }
        
        for row in rows {
            
            let view = GalleryRow()
            view.update(sample: row)
            addSubview(view)
            views.append(view)
        }
    }
}
