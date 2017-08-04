//
//  GeocodingController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 06/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class GeocodingController : BaseGeocodingController, UITableViewDataSource, UITextFieldDelegate {

    var searchQueueSize: Int = 0
    
    var addresses = [NTGeocodingResult]()
    
    static let identifier = "AutocompleteRowId"
    
    var service: NTGeocodingService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = GeocodingView()
        view = contentView
  
        let folder = Utils.createDirectory(name: BaseGeocodingView.PACKAGE_FOLDER)
        contentView.manager = NTCartoPackageManager(source: BaseGeocodingView.SOURCE, dataFolder: folder)
        
        setOnlineMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        (contentView as! GeocodingView).inputField.delegate = self
        (contentView as! GeocodingView).resultTable.delegate = self
        (contentView as! GeocodingView).resultTable.dataSource = self
        
        if (contentView.hasLocalPackages()) {
            contentView.showLocalPackages()
        } else {
            (contentView as! GeocodingView).showBannerInsteadOfSearchBar()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        (contentView as! GeocodingView).inputField.delegate = nil
        (contentView as! GeocodingView).resultTable.delegate = nil
        (contentView as! GeocodingView).resultTable.dataSource = nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        (contentView as! GeocodingView).closeTextField()
        geocode(text: (contentView as! GeocodingView).inputField.text!, autocomplete: false)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        (contentView as! GeocodingView).resultTable.isHidden = false
        
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
        cell.textLabel?.text = result.getPrettyAddress()
        cell.textLabel?.font = (contentView as! GeocodingView).font
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = Colors.lightTransparentGray
        cell.textLabel?.backgroundColor = Colors.fromRgba(red: 0, green: 0, blue: 0, alpha: 0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // This controller contains two tableviews: package table and autocomplete table,
        // both delegates direct here. Make the distinction:
        if (tableView.isEqual((contentView as! GeocodingView).resultTable)) {
            (contentView as! GeocodingView).closeTextField()
            let result = addresses[indexPath.row]
            showResult(result: result)
        } else {
            // Base class handles package table actions
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }
    
    func geocode(text: String, autocomplete: Bool) {
        
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
            
            if (self.service is NTPackageManagerGeocodingService) {
                (self.service as! NTPackageManagerGeocodingService).setAutocomplete(autocomplete)
            } else {
                (self.service as! NTPeliasOnlineGeocodingService).setAutocomplete(autocomplete)
            }
            
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
                    
                    (self.contentView as! GeocodingView).resultTable.reloadData()
                    return
                }
                
                if (count > 0) {
                    
                    self.showResult(result: results?.get(0))
                }
                
                print("Geocoding took: " + String(describing: duration))
            }
        }
    }
    
    func showResult(result: NTGeocodingResult!) {
        let title = ""
        let description = result.getPrettyAddress()
        let goToPosition = true
        
        self.contentView.showResult(result: result, title: title, description: description, goToPosition: goToPosition)
    }
    
    override func setOnlineMode() {
        service = NTPeliasOnlineGeocodingService(apiKey: API_KEY)
    }
    
    override func setOfflineMode() {
        service = NTPackageManagerGeocodingService(packageManager: contentView.manager)
    }
}








