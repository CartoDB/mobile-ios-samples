
import UIKit

class VisBaseController: UIViewController {
    
    var mapView: NTMapView?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Carto VizJson Map";
        
        // Initialize MapView and set it as the view
        mapView = NTMapView();
        view = mapView;
    }
}

/*************
    BUILDER
 *************/

class MyCartoVisBuilder : NTCartoVisBuilder {
    
    var mapView: NTMapView?;
    
    convenience init(mapView: NTMapView) {
        self.init();
        self.mapView = mapView;
    }
    
    override func add(_ layer: NTLayer!, attributes: NTVariant!) {
        self.mapView!.getLayers().add(layer);
    }
    
    override func setCenter(_ mapPos: NTMapPos!) {
        let position = mapView?.getOptions().getBaseProjection().fromWgs84(mapPos)
        mapView?.setFocus(position, durationSeconds: 0)
    }
    
    override func setZoom(_ zoom: Float) {
        mapView?.setZoom(zoom, durationSeconds: 0)
    }
}

/*************
    EXTENSIONS
 *************/

extension NTMapView {
    func updateVis(_ url: String) {
        
        DispatchQueue.global().async {
            
            self.getLayers().clear();
            
            let loader = NTCartoVisLoader();

            loader?.setDefaultVectorLayerMode(true);
            
            let builder = MyCartoVisBuilder(mapView: self);
            
            loader?.loadVis(builder, visURL: url);
        }
    }
}

