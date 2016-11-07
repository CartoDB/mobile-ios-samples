
class FontsVisController : VisBaseController
{
    override func getName() -> String { return "Fonts VisJson"; }
    
    override func getDescription() -> String { return "Displays text on the map"; }
    
    var url = "https://cartomobile-team.carto.com/u/nutiteq/api/v2/viz/13332848-27da-11e6-8801-0e5db1731f59/viz.json";
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        
        mapView?.updateVis(url);
    }
}
