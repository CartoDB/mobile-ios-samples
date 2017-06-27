//
//  ViewController.swift
//  Feature Demo
//
//  Created by Aare Undo on 16/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, GalleryDelegate {
    
    var contentView: MainView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        contentView = MainView()
        contentView?.galleryDelegate = self
        
        view = contentView

        contentView?.addRows(rows: Samples.list)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "FEATURE DEMO"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    func galleryItemClick(item: GalleryRow) {
        
        let controller = item.sample.controller!
        controller.sample = item.sample
        controller.title = item.sample.title
        
        navigationController?.pushViewController(controller, animated: true)
    }

}

