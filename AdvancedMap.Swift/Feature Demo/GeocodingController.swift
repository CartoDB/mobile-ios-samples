//
//  GeocodingController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 06/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class GeocodingController : BaseController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var contentView: GeocodingView!
    
    var service: NTOSMOfflineGeocodingService!
    
    var searchQueueSize: Int = 0
    
    var addresses = [NTGeocodingResult]()
    
    static let identifier = "AutocompleteRowId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = GeocodingView()
        view = contentView
        
        let path = Bundle.main.path(forResource: "estonia-latest", ofType: "sqlite")
        service = NTOSMOfflineGeocodingService(path: path)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        
        contentView.inputField.delegate = self
        contentView.resultTable.delegate = self
        contentView.resultTable.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        contentView.inputField.delegate = nil
        contentView.resultTable.delegate = nil
        contentView.resultTable.dataSource = nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentView.inputField.resignFirstResponder()
        contentView.resultTable.isHidden = true
        
        geocode(text: contentView.inputField.text!, autocomplete: false)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        contentView.resultTable.isHidden = false
        
        let substring = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        geocode(text: substring, autocomplete: true)
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GeocodingController.identifier, for: indexPath as IndexPath)
        
        let result = addresses[indexPath.row]
        cell.tag = indexPath.row
        cell.textLabel?.text = getPrintableAdress(result: result)
        cell.textLabel?.font = contentView.font
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = Colors.lightTransparentGray
        cell.textLabel?.backgroundColor = Colors.fromRgba(red: 0, green: 0, blue: 0, alpha: 0)
        return cell
    }
    
    func geocode(text: String, autocomplete: Bool) {
        
        contentView.hideGeocodingResult()
        
        searchQueueSize += 1
        
        DispatchQueue.global().async {
            if (self.searchQueueSize - 1 > 0) {
                // Cancel the request if we have additional pending requests queued
                print("Gecoding: pending request, skipping")
                return
            }
            
            self.searchQueueSize -= 1
            
            let start = NSDate.timeIntervalSinceReferenceDate
            
            let request = NTGeocodingRequest(projection: self.contentView.projection, query: text)
            
            self.service.setAutocomplete(autocomplete)
            let results = self.service.calculateAddresses(request)
            
            let duration = NSDate.timeIntervalSinceReferenceDate - start
            let count: Int = Int((results?.size())!)
            
            DispatchQueue.main.async {
                // In autocomplete mode just fill the autocomplete address list and reload tableview
                // In full geocode mode, show the result
                if (autocomplete) {
                    self.addresses.removeAll()
                    
                    for var i in 00..<count {
                        let result = (results?.get(Int32(i)))!
                        self.addresses.append(result)
                        i += 1
                        
                    }
                    
                    self.contentView.resultTable.reloadData()
                    return
                }
                
                if (count > 0) {
                    
                    let result = results?.get(0)
                    let title = ""
                    let description = self.getPrintableAdress(result: result!)
                    let goToPosition = true
                    
                    self.contentView.showResult(result: result, title: title, description: description, goToPosition: goToPosition)
                }
                
                print("Geocoding took: " + String(describing: duration))
            }
        }
    }
    
    func getPrintableAdress(result: NTGeocodingResult) -> String {
        
        let address = result.getAddress()
        var string = ""
        
        if ((address?.getName().characters.count)! > 0) {
            string += (address?.getName())!
        }
        
        if ((address?.getStreet().characters.count)! > 0) {
            string.addCommaIfNecessary()
            string += (address?.getHouseNumber())!
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








