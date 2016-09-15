#import "MyMergedRasterTileDataSource.h"

@interface  MyMergedRasterTileDataSource() {
}

@property (strong, nonatomic) NTTileDataSource* dataSource1;
@property (strong, nonatomic) NTTileDataSource* dataSource2;

@end;

@implementation MyMergedRasterTileDataSource

-(id)initWithDataSource1: (NTTileDataSource*)dataSource1 dataSource2: (NTTileDataSource*)dataSource2
{
    self = [super initWithMinZoom:MIN([dataSource1 getMinZoom], [dataSource2 getMinZoom])
                          maxZoom:MAX([dataSource1 getMaxZoom], [dataSource2 getMaxZoom])];
    if (self != nil) {
        _dataSource1 = dataSource1;
        _dataSource2 = dataSource2;
    }
    return self;
}

-(NTTileData *)loadTile: (NTMapTile*)tile
{
    NTTileData* tileData1 = [_dataSource1 loadTile:tile];
    NTTileData* tileData2 = [_dataSource2 loadTile:tile];
    if (!tileData1) {
        return tileData2;
    }
    
    if (!tileData2) {
        return tileData1;
    }
    
    // Create bitmaps
    NTBitmap* tileBitmap1 = [NTBitmap createFromCompressed: tileData1.getData];
    NTBitmap* tileBitmap2 = [NTBitmap createFromCompressed: tileData2.getData];
  
    // Combine the bitmaps
    UIImage* image1 = [NTBitmapUtils createUIImageFromBitmap: tileBitmap1];
    UIImage* image2 = [NTBitmapUtils createUIImageFromBitmap: tileBitmap2];
    
    CGSize imageSize = CGSizeMake(CGImageGetWidth(image1.CGImage), CGImageGetHeight(image2.CGImage));
    
    UIGraphicsBeginImageContext(imageSize);

    [image1 drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    [image2 drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    
    // Extract image
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  
    NTBitmap* tileBitmap = [NTBitmapUtils createBitmapFromUIImage:image];

    return [[NTTileData alloc] initWithData: tileBitmap.compressToInternal];
}

@end
