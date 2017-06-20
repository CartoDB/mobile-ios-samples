//
//  BaseController.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class BaseController : UIViewController {
    
    var sample: Sample!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = sample.title
    }
    
    func onCellSelected(item: NSObject) {
        
    }
}
