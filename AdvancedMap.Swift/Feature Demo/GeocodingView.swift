//
//  GeocodingView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 06/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class GeocodingView : BaseGecodingView {
    
    var inputField: UITextField!
    var resultTable: UITableView!
    
    let font = UIFont(name: "HelveticaNeue", size: 15)!
    
    let placeholder = "Type address..."

    convenience init() {
        self.init(frame: CGRect.zero)
        
        let attributes: [String: AnyObject]? = [
            NSForegroundColorAttributeName: Colors.fromRgba(red: 200, green: 200, blue: 200, alpha: 255),
            NSFontAttributeName: font
        ]
        
        initializeGeocodingView(popupTitle: Texts.geocodingInfoHeader, popupDescription: Texts.geocodingInfoContainer)

        inputField = UITextField()
        inputField.textColor = UIColor.white
        inputField.backgroundColor = Colors.darkTransparentGray
        inputField.autocorrectionType = .no
        inputField.font = font
        // Text padding
        inputField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        inputField.leftViewMode = .always
 
        inputField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        addSubview(inputField)
        
        resultTable = UITableView()
        resultTable.isHidden = true
        resultTable.register(UITableViewCell.self, forCellReuseIdentifier: GeocodingController.identifier)
        
        addSubview(resultTable)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let padding: CGFloat = 5
        let x: CGFloat = padding
        var y: CGFloat = Device.trueY0() + padding
        let w: CGFloat = frame.width - 2 * padding
        var h: CGFloat = 60
        
        inputField.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h
        h = 240
        
        resultTable.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    override func addRecognizers() {
        super.addRecognizers()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.addGestureRecognizer(recognizer)
    }
    
    override func removeRecognizers() {
        super.removeRecognizers()
    }
    
    func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        inputField.resignFirstResponder()
        resultTable.isHidden = true
    }
    
    func hideGeocodingResult() {
        
    }
    
}
