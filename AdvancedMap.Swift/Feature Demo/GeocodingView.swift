//
//  GeocodingView.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 06/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class GeocodingView : BaseGeocodingView, UIGestureRecognizerDelegate {
    
    var inputField: UITextField!
    var resultTable: UITableView!
    
    let font = UIFont(name: "HelveticaNeue", size: 14)!
    
    let placeholder = "Type address..."

    convenience init() {
        self.init(frame: CGRect.zero)
        
        let attributes: [NSAttributedStringKey: AnyObject]? = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): Colors.fromRgba(red: 200, green: 200, blue: 200, alpha: 255),
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font
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
        resultTable.register(GeocodingResultCell.self, forCellReuseIdentifier: GeocodingController.identifier)
        resultTable.backgroundColor = Colors.fromRgba(red: 0, green: 0, blue: 0, alpha: 0)
        resultTable.allowsSelection = true
        resultTable.isUserInteractionEnabled = true
        
        addSubview(resultTable)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.frame.contains(resultTable.frame))! {
            return true
        }
        
        return false
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let padding: CGFloat = 5
        let x: CGFloat = padding
        var y: CGFloat = Device.trueY0() + padding
        let w: CGFloat = frame.width - 2 * padding
        var h: CGFloat = 50
        
        inputField.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h + 1
        h = 240

        resultTable.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    override func addRecognizers() {
        super.addRecognizers()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        recognizer.delegate = self
        self.addGestureRecognizer(recognizer)
    }
    
    override func removeRecognizers() {
        super.removeRecognizers()
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        inputField.resignFirstResponder()
        resultTable.isHidden = true
    }
    
    func closeTextField() {
        inputField.resignFirstResponder()
        resultTable.isHidden = true
    }
    
    
    func showBannerInsteadOfSearchBar() {
        inputField.isHidden = true
        banner.show(text: "DOWNLOAD A PACKAGE TO START GEOCODING")
    }
    
    func showSearchBar() {
        inputField.isHidden = false
        banner.hide()
    }
}










