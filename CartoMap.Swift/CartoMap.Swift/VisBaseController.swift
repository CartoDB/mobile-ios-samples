
import UIKit

class VisBaseController: GLKViewController {
    
    func getName() -> String { return "ViewController"; }
    func getDescription() -> String { return "CARTO.js API visjson base class"; }
    
    var mapView: NTMapView?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Carto VizJson Map";
        
        // Initialize MapView and set it as the view
        mapView = NTMapView();
        view = mapView;
        
        // Add default base layer
        let baseLayer = NTCartoOnlineVectorTileLayer(style: NTCartoBaseMapStyle.CARTO_BASEMAP_STYLE_DEFAULT);
        mapView?.getLayers().add(baseLayer);
        
        // GLKViewController-specific parameters for smoother animations
        self.resumeOnDidBecomeActive = true;
        self.preferredFramesPerSecond = 60;
        
        mapView?.setZoom(2, durationSeconds: 2);
        
        title = getName();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        // GLKViewController-specific, do on-demand rendering instead of constant redrawing
        // This is VERY IMPORTANT as it stops battery drain when nothing changes on the screen!
        isPaused = true;
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
}

/*************
    EXTENSIONS
 *************/

extension NTMapView {
    func updateVis(_ url: String) {
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            
            self.getLayers().clear();
            
            let loader = NTCartoVisLoader();

            loader?.setDefaultVectorLayerMode(true);
            
            let fontData = NTAssetUtils.loadAsset("carto-fonts.zip");
            loader?.setVectorTileAssetPackage(NTZippedAssetPackage(zip: fontData));
            
            let builder = MyCartoVisBuilder(mapView: self);
            
            loader?.loadVis(builder, visURL: url);
        }
    }
}

