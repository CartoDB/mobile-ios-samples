#import <CartoMobileSDK/CartoMobileSDK.h>

/*
 * A custom raster tile data source that loads tiles from two sources and then blends
 * them into a single tile.
 */
@interface  MyMergedRasterTileDataSource : NTTileDataSource

-(id)initWithDataSource1: (NTTileDataSource*)dataSource1 dataSource2: (NTTileDataSource*)dataSource2;

-(NTTileData*)loadTile: (NTMapTile*)tile;

@end