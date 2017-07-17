//
//  ClusteringController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 28/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class ClusteringController : BaseController {
    
    var contentView: ClusteringView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = ClusteringView()
        view = contentView
      
        let cBuilder = ClusterBuilder()
        cBuilder?.image = UIImage(named: "marker_black.png")
        cBuilder?.elements = [Int: NTMarkerStyle]()

        contentView.initializeClusterLayer(builder: cBuilder!)
        
        DispatchQueue.global().async {

            let path = Bundle.main.path(forResource: "cities15000", ofType: "geojson")
            
            guard let json = try? NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue) else {
                return
            }
            
            // This is the style of a non-cluster element
            // This element will be displayed when clustering animation completes and it's no longer a cluster
            let mBuilder = NTMarkerStyleBuilder()
            mBuilder?.setBitmap(NTBitmapUtils.createBitmap(from: cBuilder?.image))
            mBuilder?.setSize(30)
            
            let style = mBuilder?.buildStyle()
            
            // Read GeoJSON, parse it using SDK GeoJSON parser
            let reader = NTGeoJSONGeometryReader()
            reader?.setTargetProjection(self.contentView.map.getOptions().getBaseProjection())
            
            let features = reader?.readFeatureCollection(json as String!)
            
            let elements = NTVectorElementVector()
            let total = Int((features?.getFeatureCount())!)
            
            
            for i in stride(from: 0, to: total, by: 1) {
                // This data set features point geometry, however, it can also be LineGeometry or PolygonGeometry
                let geometry = features?.getFeature(Int32(i)).getGeometry() as? NTPointGeometry
                elements?.add(NTMarker(geometry: geometry, style: style))
            }
            
            DispatchQueue.main.async(execute: {
                self.contentView.addClusters(elements: elements!)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
    }
    
}
