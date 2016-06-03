#import <CartoMobileSDK/CartoMobileSDK.h>

/**
 * A custom popup class
 */
@interface CustomPopup : NTPopup

-(id)initWithBaseBillboard: (NTBillboard*)baseBillboard text: (NSString*)text;

-(NTBitmap*)drawBitmap: (NTScreenPos*)anchorScreenPos screenWidth: (float)screenWidth screenHeight: (float)screenHeight dpToPX: (float)dpToPX;

@end
