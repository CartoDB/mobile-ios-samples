
class DotsVisController : VisBaseController
{
    override func getName() -> String { return "Dots VisJson"; }
    
    override func getDescription() -> String { return "Shows dots on the map"; }
    
    var url = "https://documentation.cartodb.com/api/v2/viz/236085de-ea08-11e2-958c-5404a6a683d5/viz.json";
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        mapView?.updateVis(url);
    }
}