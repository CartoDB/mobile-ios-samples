//
//  VectorObjectEditingController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 28/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class VectorObjectEditingController : BaseController, VectorElementSelectDelegate, VectorElementDeselectDelegate {
    
    var contentView: VectorObjectEditingView!
    
    var editListener: EditEventListener!
    var selectListener: VectorElementSelectListener!
    var deselectListener: VectorElementDeselectListener!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = VectorObjectEditingView()
        view = contentView
        
        editListener = EditEventListener()
        selectListener = VectorElementSelectListener()
        deselectListener = VectorElementDeselectListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        
        editListener?.initialize(source: contentView.editSource)
        contentView.editLayer.setVectorEditEventListener(editListener)
        
        
        selectListener?.delegate = self
        contentView.editLayer.setVectorElementEventListener(selectListener)
        
        
        deselectListener?.delegate = self
        contentView.map.setMapEventListener(deselectListener)
        
        contentView.addElements()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        contentView.editLayer.setVectorEditEventListener(nil)
        
        selectListener.delegate = nil
        contentView.editLayer.setVectorElementEventListener(nil)
        
        deselectListener.delegate = nil
        contentView.map.setMapEventListener(nil)
    }
    
    func selected(element: NTVectorElement) {
        contentView.editLayer.setSelectedVectorElement(element)
    }
    
    func deselect() {
        contentView.editLayer.setSelectedVectorElement(nil)
    }
}
