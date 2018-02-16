//
//  Extensions.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 27/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(from: Int, to: Int) -> String {
        return substring(from: from).substring(to: to)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }

    func lastIndexOf(s: String) -> Int {
        
        if let r: Range<Index> = range(of: s) {
            return distance(from: self.startIndex, to: r.lowerBound)
        }
        
        return -1
    }
    
    mutating func addCommaIfNecessary() {
        if (count > 0) {
            self += ", "
        }
    }
}

// Snippet copied from:
// https://stackoverflow.com/questions/28496093/making-text-bold-using-attributed-string-in-swift
extension NSMutableAttributedString {
    @discardableResult func bold(_ text:String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 9)!]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}

extension UIView {
    
    func addSquareShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    func addRoundShadow() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset =  CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 0.0
        layer.masksToBounds = false
        layer.cornerRadius = frame.width / 2
    }
}

extension NTPackageInfo {
    
    func getSizeInMB() -> Double {
        let bytesInMB = 1048576.0
        return round(Double(self.getSize()) / bytesInMB * 10.0) / 10.0
    }
}

extension NTGeocodingResult {
    
    func getPrettyAddress() -> String {
        
        let address = self.getAddress()
        var string = ""
        
        if ((address?.getName().count)! > 0) {
            string += (address?.getName())!
        }
        
        if ((address?.getStreet().count)! > 0) {
            string.addCommaIfNecessary()
            string += (address?.getStreet())!
        }
        
        if ((address?.getHouseNumber().count)! > 0) {
            string += " " + (address?.getHouseNumber())!
        }
        
        if ((address?.getNeighbourhood().count)! > 0) {
            string.addCommaIfNecessary()
            string += (address?.getNeighbourhood())!
        }
        
        if ((address?.getLocality().count)! > 0) {
            string.addCommaIfNecessary()
            string += (address?.getLocality())!
        }
        
        if ((address?.getCounty().count)! > 0) {
            string.addCommaIfNecessary()
            string += (address?.getCounty())!
        }
        
        if ((address?.getRegion().count)! > 0) {
            string.addCommaIfNecessary()
            string += (address?.getRegion())!
        }
        
        if ((address?.getCountry().count)! > 0) {
            string.addCommaIfNecessary()
            string += (address?.getCountry())!
        }
        
        return string
    }
    
    func getType() -> String {
        
        let address = self.getAddress()
        
        if (address?.getName() != "") {
            return "Point of Interest"
        } else if (address?.getHouseNumber() != "") {
            return "Address"
        } else if (address?.getStreet() != "") {
            return "Street"
        } else if (address?.getNeighbourhood() != "") {
            return "Neighbourhood"
        } else if (address?.getLocality() != "") {
            return "Town/village"
        } else if (address?.getCounty() != "") {
            return "County"
        } else if (address?.getRegion() != "") {
            return "Region"
        } else if (address?.getCountry() != "") {
            return "Country"
        } else {
            return ""
        }
    }
}

extension NTPackageInfoVector {
    func toList() -> [NTPackageInfo] {
        
        var list = [NTPackageInfo]()
        
        let total = Int(size())
        
        for i in stride(from: 0, to: total, by: 1) {
            let package = get(Int32(i))
            list.append(package!)
        }
        
        return list
    }
}







