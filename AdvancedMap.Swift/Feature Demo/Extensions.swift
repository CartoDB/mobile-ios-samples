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
    
    func index(of: Character) -> Int {
        guard let index = characters.index(of: of) else {
            return -1
        }
        return distance(from: startIndex, to: index)
    }
    
    func lastIndexOf(s: String) -> Int {
        
        if let r: Range<Index> = range(of: s) {
            return distance(from: self.startIndex, to: r.lowerBound)
        }
        
        return -1
    }
    
    mutating func addCommaIfNecessary() {
        if (characters.count > 0) {
            self += ", "
        }
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
        
        if ((address?.getName().characters.count)! > 0) {
            string += (address?.getName())!
        }
        
        if ((address?.getStreet().characters.count)! > 0) {
            string.addCommaIfNecessary()
            string += (address?.getStreet())!
        }
        
        if ((address?.getHouseNumber().characters.count)! > 0) {
            string += " " + (address?.getHouseNumber())!
        }
        
        if ((address?.getNeighbourhood().characters.count)! > 0) {
            string.addCommaIfNecessary()
            string += (address?.getNeighbourhood())!
        }
        
        if ((address?.getLocality().characters.count)! > 0) {
            string.addCommaIfNecessary()
            string += (address?.getLocality())!
        }
        
        if ((address?.getCounty().characters.count)! > 0) {
            string.addCommaIfNecessary()
            string += (address?.getCounty())!
        }
        
        if ((address?.getRegion().characters.count)! > 0) {
            string.addCommaIfNecessary()
            string += (address?.getRegion())!
        }
        
        if ((address?.getCountry().characters.count)! > 0) {
            string.addCommaIfNecessary()
            string += (address?.getCountry())!
        }
        
        return string
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







