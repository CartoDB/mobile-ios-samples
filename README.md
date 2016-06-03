iOS sample app with Carto Mobile SDK 1.0
========================================

This is sample for Carto Mobile SDK (http://www.cartodb.com), demonstrating several key features.

## Download and documentation
  * Carto Mobile SDK for iOS (CartoMobileSDK.framework) should be linked or copied to the root folder
   of the project

## Features
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

## Running
The app works on iOS 7 or newer.
