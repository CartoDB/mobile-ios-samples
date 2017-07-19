//
//  GeocodingController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 06/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class GeocodingController : BaseController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, PackageDownloadDelegate, ClickDelegate {
    
    var contentView: GeocodingView!
    
    var service: NTPackageManagerGeocodingService!
    
    var searchQueueSize: Int = 0
    
    var addresses = [NTGeocodingResult]()
    
    static let identifier = "AutocompleteRowId"
    
    var listener: PackageListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = GeocodingView()
        view = contentView
        
        listener = PackageListener()
        
        let folder = Utils.createDirectory(name: "geocodingpackages")
        contentView.manager = NTCartoPackageManager(source: BaseGeocodingView.SOURCE, dataFolder: folder)
        
        service = NTPackageManagerGeocodingService(packageManager: contentView.manager)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        
        listener?.delegate = self
        
        contentView.inputField.delegate = self
        contentView.resultTable.delegate = self
        contentView.resultTable.dataSource = self
        
        contentView.manager?.setPackageManagerListener(listener)
        contentView.manager?.start()
        contentView.manager?.startPackageListDownload()
        
        contentView.packageContent.table.delegate = self
        contentView.popup.popup.header.backButton.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        listener?.delegate = nil
        
        contentView.inputField.delegate = nil
        contentView.resultTable.delegate = nil
        contentView.resultTable.dataSource = nil
        
        contentView.manager?.setPackageManagerListener(nil)
        contentView.manager?.stop(false)
    }
    
    func click(sender: UIView) {
        // Currently the only generic button on this page is the popup back button,
        // no need to type check.
        contentView.onPopupBackButtonClick()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentView.closeTextField()
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
        cell.textLabel?.text = result.getPrettyAddress()
        cell.textLabel?.font = contentView.font
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = Colors.lightTransparentGray
        cell.textLabel?.backgroundColor = Colors.fromRgba(red: 0, green: 0, blue: 0, alpha: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // We have two tableviews in this controller, one for search results and the other for packages
        if (tableView == contentView.resultTable) {
            contentView.closeTextField()
            let result = addresses[indexPath.row]
            showResult(result: result)
        } else {
            let package = contentView.packageContent.packages[indexPath.row]
            contentView.onPackageClick(package: package)
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

    
    func listDownloadComplete() {
        contentView.updatePackages()
    }
    
    func listDownloadFailed() {
        // TODO
    }
    
    func statusChanged(sender: PackageListener, status: NTPackageStatus) {
        contentView.onStatusChanged(status: status)
    }
    
    func downloadComplete(sender: PackageListener, id: String) {
        contentView.downloadComplete(id: id)
    }
    
    func downloadFailed(sender: PackageListener, errorType: NTPackageErrorType) {
        // TODO
    }
    
}








