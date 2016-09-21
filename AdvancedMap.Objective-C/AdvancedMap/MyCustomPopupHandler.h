#import <CartoMobileSDK/CartoMobileSDK.h>

/**
 * A custom popup handler class
 */
@interface MyCustomPopupHandler : NTCustomPopupHandler

-(id)initWithText:(NSString*)text;

-(NTBitmap*)onDrawPopup:(NTPopupDrawInfo *)popupDrawInfo;

-(BOOL)onPopupClicked:(NTPopupClickInfo *)popupClickInfo;

@end
