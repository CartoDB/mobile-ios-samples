
#import "MapBaseController.h"
#import "Sources.h"
#import "BaseMapsView.h"
#import "Languages.h"

/** BaseMapsController **/
@interface BaseMapsController : MapBaseController <UITableViewDelegate, StyleUpdateDelegate>

@end

@implementation BaseMapsController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.contentView = [[BaseMapsView alloc] init];
    self.view = self.contentView;
    
    // Zoom to Central Europe so some texts would be visible
    NTMapPos *position = [[NTMapPos alloc] initWithX:15.2551 y:54.5260];
    position = [[[self.contentView.mapView getOptions] getBaseProjection] fromWgs84:position];
    
    [self.contentView.mapView setFocusPos:position durationSeconds:0];
    [self.contentView.mapView setZoom:5 durationSeconds:0];
    
    BaseMapsView *view = ((BaseMapsView *)self.contentView);
    
    NSMutableArray *languages = [Languages getList];
    [view.languageContent addLanguagesWithLanguages:languages];
    
    [view.styleContent highlightDefault];
    // Get initial highlighted element
    previous = [view.styleContent.cartoVector.list objectAtIndex:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Default values for osm, tiletype and style, respectively
//    [(BaseMapsView *)self.contentView updateBaseLayer:CARTO_VECTOR_SOURCE :@"Vector" :@"voyager"];
    
    // Default language
//    [self.contentView updateLanguage:@""];
    
    BaseMapsView *view = ((BaseMapsView *)self.contentView);
    
    [view addRecognizer:self view:view.styleButton action:@selector(styleButtonTap:)];
    [view addRecognizer:self view:view.languageButton action:@selector(languageButtonTap:)];
    
    view.styleContent.cartoVector.delegate = self;
    view.styleContent.mapzen.delegate = self;
    view.styleContent.cartoRaster.delegate = self;
    
    view.languageContent.table.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

//    self.listener = nil;
//    self.vectorLayer = nil;
//    [self updateListener];
    
    BaseMapsView *view = ((BaseMapsView *)self.contentView);
    
    [view removeRecognizerFrom: view.styleButton];
    [view removeRecognizerFrom: view.languageButton];
    
    view.styleContent.cartoVector.delegate = nil;
    view.styleContent.mapzen.delegate = nil;
    view.styleContent.cartoRaster.delegate = nil;
    
    view.languageContent.table.delegate = nil;
}

- (void)styleButtonTap:(UITapGestureRecognizer *)recognizer {
    
    [((BaseMapsView *)self.contentView) setBasemapContent];
    
    [self.contentView.popup show];
}

- (void)languageButtonTap:(UITapGestureRecognizer *)recognizer {
    
    [((BaseMapsView *)self.contentView) setLanguageContent];
    
    [self.contentView.popup show];
}

StylePopupContentSectionItem *previous;

- (void)styleClickedWithSelection:(StylePopupContentSectionItem *)selection source:(NSString *)source {
    
    BaseMapsView *view = ((BaseMapsView *)self.contentView);
    
    [view.popup hide];
    [view updateBaseLayer:selection.label.text :source];
    
    if (previous != nil) {
        [previous normalize];
    } else {
        [view.styleContent normalizeDefaultHighlight];
    }
    
    [selection highlight];
    previous = selection;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseMapsView *view = ((BaseMapsView *)self.contentView);
    
    Language *language = [view.languageContent.languages objectAtIndex:indexPath.row];
    [view.popup hide];
    
    [view updateLanguage: [language value]];
}

@end




