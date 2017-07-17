//
//  VectorObjectEditingController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 28/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class VectorObjectEditingController : BaseController, VectorElementSelectDelegate, VectorElementDeselectDelegate, EditEventDelegate {
    
    var contentView: VectorObjectEditingView!
    
    var editListener: EditEventListener!
    var selectListener: VectorElementSelectListener!
    var deselectListener: VectorElementDeselectListener!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = VectorObjectEditingView()
        view = contentView
        
        editListener = EditEventListener()
        editListener?.initialize()
        
        selectListener = VectorElementSelectListener()
        deselectListener = VectorElementDeselectListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        
        contentView.editLayer.setVectorEditEventListener(editListener)
        
        selectListener?.delegate = self
        contentView.editLayer.setVectorElementEventListener(selectListener)
        
        
        deselectListener?.delegate = self
        contentView.map.setMapEventListener(deselectListener)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.deleteClick(_:)))
        contentView.trashCan.addGestureRecognizer(recognizer)
        
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
        
        contentView.trashCan.gestureRecognizers?.forEach(contentView.trashCan.removeGestureRecognizer)
    }
    
    func deleteClick(_ sender: UITapGestureRecognizer) {
        contentView.editSource.remove(contentView.editLayer.getSelectedVectorElement())
    }
    
    func selected(element: NTVectorElement) {
        contentView.editLayer.setSelectedVectorElement(element)
        DispatchQueue.main.async {
            self.contentView.trashCan.isHidden = false
        }
        
    }
    
    func deselect() {
        contentView.editLayer.setSelectedVectorElement(nil)
        DispatchQueue.main.async {
            self.contentView.trashCan.isHidden = true
        }
    }
    
    func onDelete(element: NTVectorElement) {
        contentView.editSource.remove(element)
        deselect()
    }
}





