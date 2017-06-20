//
//  StyleChoiceController.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import  UIKit

class StyleChoiceController : BaseController, UITableViewDelegate, StyleUpdateDelegate {
    
    var contentView: StyleChoiceView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        contentView = StyleChoiceView()
    
        view = contentView
        
        contentView.languageContent.addLanguages(languages: Languages.list)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        
        contentView.languageContent.table.delegate = self
        
        contentView.baseMapContent.nutiteq.delegate = self
        contentView.baseMapContent.mapzen.delegate = self
        contentView.baseMapContent.carto.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        contentView.languageContent.table.delegate = nil
        
        contentView.baseMapContent.nutiteq.delegate = nil
        contentView.baseMapContent.mapzen.delegate = nil
        contentView.baseMapContent.carto.delegate = nil
    }
    
    func styleClicked(selection: String, source: String) {
        contentView.popup.hide()
        contentView.updateBaseLayer(selection: selection, source: source)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = contentView.languageContent.languages[indexPath.row]
        contentView.popup.hide()
        contentView.updateMapLanguage(language: language.value)
    }
    
}
