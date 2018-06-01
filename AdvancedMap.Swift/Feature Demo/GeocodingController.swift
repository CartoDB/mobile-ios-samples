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
        
//        let source = "http://137.117.212.254/maparea/v2/carto.streets/1/{tilemask}.mbtiles?appToken=9dd6ef62-c1b2-4e8c-b3ff-90fbf979c87b"
//        contentView.manager = NTCartoPackageManager(source: source, dataFolder: folder)
        contentView.manager = NTCartoPackageManager(source: BaseGeocodingView.SOURCE, dataFolder: folder)
        
        setOnlineMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        (contentView as! GeocodingView).inputField.delegate = self
        (contentView as! GeocodingView).resultTable.delegate = self
        (contentView as! GeocodingView).resultTable.dataSource = self
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
        
        let id = GeocodingController.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: id) as! GeocodingResultCell

        let result = addresses[indexPath.row]
        cell.update(result: result)
        
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
                (self.service as! NTMapBoxOnlineGeocodingService).setAutocomplete(autocomplete)
            }
            
            //request?.setLocation(self.contentView.projection.fromWgs84(NTMapPos(x: -1.0861967, y: 61.2675)))
            //request?.setLocationRadius(10000000.0)
            
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
        
        (self.contentView as! GeocodingView).showResult(result: result, title: title, description: description, goToPosition: goToPosition)
    }
    
    override func setOnlineMode() {
        super.setOnlineMode()
        service = NTMapBoxOnlineGeocodingService(accessToken: BaseGeocodingController.MAPBOX_KEY)
        
        (contentView as! GeocodingView).showSearchBar()
    }
    
    override func setOfflineMode() {
        super.setOfflineMode()
        service = NTPackageManagerGeocodingService(packageManager: contentView.manager)
        
        if ((contentView as! GeocodingView).hasLocalPackages()) {
            (contentView as! GeocodingView).showLocalPackages()
            (contentView as! GeocodingView).showSearchBar()
        } else {
            (contentView as! GeocodingView).showBannerInsteadOfSearchBar()
        }
    }
}








