//
//  EditEventListener.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 29/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class EditEventListener: NTVectorEditEventListener {
    
    var source: NTLocalVectorDataSource!
    
    var styleNormal, styleVirtual: NTPointStyle!
    
    func initialize(source: NTLocalVectorDataSource) {
        
        self.source = source
        
        let builder = NTPointStyleBuilder()
        builder?.setColor(Colors.navy.toNTColor())
        builder?.setSize(20)
        
        styleNormal = builder?.buildStyle()
        
        builder?.setColor(Colors.navy.toNTColor())
        builder?.setSize(15)
        
        styleVirtual = builder?.buildStyle()
    }
    
    override func onElementModify(_ element: NTVectorElement!, geometry: NTGeometry!) {
        
        if let point = element as? NTPoint {
            point.setGeometry(geometry as? NTPointGeometry)
            
        } else if let line = element as? NTLine {
            line.setGeometry(geometry as? NTLineGeometry)
            
        } else if let polygon = element as? NTPolygon {
            polygon.setGeometry(geometry as? NTPolygonGeometry)
        }
    }
    
    override func onElementDelete(_ element: NTVectorElement!) {
        source.remove(element)
    }
    
    override func onDragStart(_ dragInfo: NTVectorElementDragInfo!) -> NTVectorElementDragResult {
        return NTVectorElementDragResult.VECTOR_ELEMENT_DRAG_RESULT_MODIFY
    }
    
    override func onDragMove(_ dragInfo: NTVectorElementDragInfo!) -> NTVectorElementDragResult {
        return NTVectorElementDragResult.VECTOR_ELEMENT_DRAG_RESULT_MODIFY
    }
    
    override func onDragEnd(_ dragInfo: NTVectorElementDragInfo!) -> NTVectorElementDragResult {
        return NTVectorElementDragResult.VECTOR_ELEMENT_DRAG_RESULT_MODIFY
    }
    
    override func onSelectDragPointStyle(_ element: NTVectorElement!, dragPointStyle: NTVectorElementDragPointStyle) -> NTPointStyle! {
        
        if (dragPointStyle == NTVectorElementDragPointStyle.VECTOR_ELEMENT_DRAG_POINT_STYLE_NORMAL) {
            return styleNormal
        } else if (dragPointStyle == NTVectorElementDragPointStyle.VECTOR_ELEMENT_DRAG_POINT_STYLE_VIRTUAL) {
            return styleVirtual
        }
        
        return styleNormal
    }
}
