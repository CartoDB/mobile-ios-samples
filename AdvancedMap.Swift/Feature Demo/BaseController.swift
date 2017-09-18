//
//  BaseController.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift

class BaseController : UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    func onCellSelected(item: NSObject) {
        
    }
    
    func alert(message: String) {
        DispatchQueue.main.async {
            self.view.makeToast(message)
        }
    }
}
