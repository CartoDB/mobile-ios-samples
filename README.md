iOS sample app with CARTO Mobile SDK 4
======================================

This is sample for CARTO Mobile SDK 4.x (http://www.carto.com), demonstrating several key features.

## Get started
  1. After downloading/cloning project you need to get SDK itself
  1. Get SDK package latest dev build: [sdk4-ios-snapshot-latest.zip](https://nutifront.s3.amazonaws.com/sdk_snapshots/sdk4-ios-snapshot-latest.zip)
  1. Unzip it and copy *CartoMobileSDK.framework*  to the xCode project root folder
  1. Open project in xCode, and run on emulator or USB-connected iPhone/iPad


## SDK API documentation
  * More detailed guide in wiki: https://github.com/CartoDB/mobile-ios-samples/wiki
  * Reference: http://cartodb.github.io/mobile-ios-samples/
  * The distro zip has generated HTML reference docs in *docObjC* folder

## Use in your own app
  * You need license code based on your app ID from carto.com account, see **API Keys > Mobile Apps** section in user profile. 
  * Enabling Mobile Apps currently requires feature flag definition by superadmin!


## Samples included
1. Creating a map
   - set map location and zoom
   - setting some properties
2. Adding layers
   - Layers need Data Sources as actual data source
3. VectorTileLayer for vector-based base map
   - Online global source 
   - Offline file (Berlin sample) as another option
4. Various other layer types:
   - VectorLayer to add points, lines, polygons and markers to the map. Objects are added to backing Data Source.
   - RasterLayer for tile-based raster datasources
5. MapEventListener to get map events:
   - Click on map
   - Click on map object, including balloons and 3D objects
6. Adding Balloon Popopups "callouts" to the map
   - Some are added to the map and are always visible
   - Some are coming when you click on map, or some map object
7. Add 3D data to map
   - Two offline datasets: building in NMLDB (3D city) format, and simple 3D car in NML (3D model) format. You can reposition, rotate etc NML models via code easily.
8. **CARTO Viz.json loading**
   - Load and auto-configure map view based on some sample CARTO viz.json-s.

The app works on iOS 7 or newer.
