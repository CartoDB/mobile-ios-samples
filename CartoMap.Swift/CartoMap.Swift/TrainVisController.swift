
class TrainVisController : VisBaseController {
    
    var url = "https://mamataakella.cartodb.com/api/v2/viz/30730478-bbb5-11e5-b75c-0e5db1731f59/viz.json";
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        mapView?.updateVis(url);
    }
}
