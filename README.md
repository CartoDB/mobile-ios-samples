## iOS sample app with CARTO Mobile SDK

* Official docs: https://carto.com/docs/carto-engine/mobile-sdk/
* Reference: http://cartodb.github.io/mobile-ios-samples/

[![Build Status](https://travis-ci.org/CartoDB/mobile-ios-samples.svg?branch=master)](https://travis-ci.org/CartoDB/mobile-ios-samples)

## Installation Guide
  
* Note that we have several subprojects, for different languages (Objective-C or Swift) and level of complexity (from HelloMap to AdvancedMap), each is separate projects in Xcode point of view.*

* Set your key in `License` value of `AppDelegate.swift` before build.

#### Via CocoaPods:

The following steps assume you know what Cocoapods are and have the CL tool installed on your system.

  1. Navigate to a project's folder in the **Terminal**.
  2. Type `pod install` to download the SDK 
  3. Run the project via the **.xcworkspace** file

#### Via Carthage:

The following steps assume you know what Carthage is and have the CL tool installed on your system. Note that as SDK 4.4.0 and newer versions
are distributed as xcframeworks, you need **Carthage 0.38 or later**.

 1. Type `carthage update --use-xcframeworks` to download the SDK 
 2. Add `$(SRCROOT)/Carthage/Build/iOS` to XCode Framework Search paths (Project properties > Build )
 3. Add `Carthage/Build/iOS/CartoMobileSDK.xcframework` to XCode Embedded Binaries (Project properties > General)
 4. Remove Cocoapods references from project structure, including 'Build Phases' inside XCode IDE.

## Cocoapod Removal

These samples are, by default, designed to work with Cocoapods. In order to deintegrate Cocoapods, do the following:

  1. Navigate to a project's folder in the **Terminal**.
  2. `sudo gem install cocoapods-deintegrate cocoapods-clean`
  3. `pod deintegrate`
  4. `pod clean`
  5. Under Build Phases > Link Binary With Libraries, remove CardoMobileSDK.framework

Furthermore, note that trying to run Carthage on a project that was previously configured with cocoapoads may or may not result in errors, cf. [this](https://stackoverflow.com/questions/34642165/this-applications-bundle-identifier-does-not-match-its-code-signing-identifier) post

## Sample structure

1. **Hello Map**
    * Basic sample of how to initialize a map, set a market on the map, listen to map clicks and change the color and size of that marker.
2. **Advanced Map**
    * Base Maps
      * Base Maps - choice of different base maps, styles, tile type and language
    * Overlay Data Sources
        * Custom Raster Data Source - creating and using custom (merged) raster tile data source
        * Ground Overlay - Addoung ground-level raster overlay
        * WMS Map - WMS service raster on top of a vector base map
    * Vector Objects
        * Clustered Markers - reading data from .geojson and showing it as clusters (made from custom markers)
        * Overlays - shows how to set 2D &3D objects: lines, points, polygons, tests, popups and 3D models on the map and how to attach a click listener to them
        * Vector object editing - shows usage of an editable vector layer, with three different event listeners
    * Offline maps
        * Bundled Map - Shows usage of a numbled MBTiles file to display a map offline
        * Package Manager - Download offline map packaged with OSM
    *   Other
        *  Screencapture - Captures a rendered MapView as a Bitmap
        *  Custom Popup - Creating and using custom popups
        *  GPS Location - Shows user GPS location on the map
        *  Offline Routing - Offline routing with OpenStreetMap data packages
3. **Carto Map**
    * CARTO.js API
        * Countries Vis - Dislaying countries in different colors from a viz.json
        * Dots Vis - Showing specific dots on the map from a viz.json
        * Fonts Vis - Displaying text on the map from a viz.json
    * Maps API
        * Anonymous Raster Tile - Uses CARTO PostGIS raster data
        * Anonymous Vector Tile - Uses CARTO Maps API vector tiles
        * Named Map - CARTO data as vector tiles from a named map
    * SQL API
        *  SQL Service - Displays cities on the map vis a SQL query
    *  Torque API
        *  CARTO Torque Map - Shows Torque tiels of WWII ship movement

## Other Samples

* Android (Java and Kotlin), iPhone (Objective-C and Swift) and others: https://github.com/CartoDB/mobile-sdk-samples
