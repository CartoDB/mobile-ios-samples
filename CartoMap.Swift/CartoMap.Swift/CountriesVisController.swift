
class CountriesVisController : VisBaseController
{
    override func getName() -> String { return "Countries VisJson"; }
    
    override func getDescription() -> String { return "Displays countries in different colors"; }
    
    var url = "http://documentation.cartodb.com/api/v2/viz/2b13c956-e7c1-11e2-806b-5404a6a683d5/viz.json";
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        mapView?.updateVis(url);
    }
}