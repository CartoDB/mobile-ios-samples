//
//  Texts.swift
//  Feature Demo
//
//  Created by Aare Undo on 20/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class Texts {
    
    static let basemapInfoHeader = "CARTO BASE MAPS"
    
    static let basemapInfoContainer =
        "CARTO offers a variety of different base map styles, here are a few samples:\n \n" +
        "Nutiteq Bright is your classic style, when you want to go old school, used mainly for routing, navigation etc.\n \n" +
        "Nutiteq Gray is a bit more humble, shades of light gray, for when you need to display information on top of your base map: great for colorful visualizations.\n \n" +
        "Nutiteq Dark is dark, heavy, like the night, it's for when you're feeling extra frisky, when you want to walk on the wild side or... just for visualizations that work better with a dark background. \n \n" +
        "Mapzen and CARTO are similar in that way, the difference lies in the fact that CARTO's base maps use raster tiles, and mapzen's styles come from a different source."
    
    static let routeDownloadInfoHeader = "ROUTE DOWNLOAD"
    
    static let routeDownloadInfoContainer =
        "CARTOMobileSDK 4.1.0 uses Valhalla routing. With that, we have the option to download a specific bounding box... and that is exactly what this example does.\n\n" +
        "It first downloads the map package, then saves it to a specified folder, then downloads the routing package separately. Fun fact: routing packages are often even larger than map packages.\n\n" +
        "Long-click anywhere on the map, that's the start position – now click again to set the stop position. When you're done, the route is calculated.\n\n" +
        "Now you have the option to download that bounding box. After you download a route, a transparent visualization of the downloaded area appears on your map.\n\n" +
        "Oh, and downloaded areas stay forever. You're gonna have to uninstall the app to get rid of the bounding boxes. So be careful, don't fill your phone with bounding boxes!\n\n"
    
    static let cityDownloadInfoHeader = "CITY DOWNLOAD"
    
    static let cityDownloadInfoContainer =
        "This example lets you download specific cities. Cities are also based on bounding boxes, we used http://bboxfinder.com to cut out the bounding boxes of specific cities.\n\n" +
        "Simply click on the city you wish to download, a progress bar will appear and your're free to browse the map as you wish. You will be zoomed in to the location when the download is completed.\n\n" +
        "If you wish to see more cities on this list, simply contact CARTO or, if you're the technical kind, find this app on github.com and make a pull request."
    
    static let packageDownloadInfoHeader = "PACKAGE DOWNLOAD"
    
    static let packageDownloadInfoContainer =
        "This example lets you download pre-defined packages. The packages are mostly country-based, but some larger countries, like The United States, Russia and Germany, are municipality (or oblast etc.) based.\n\n" +
        "Simply choose a package, press download and it will start, the progress will be displayed in the list and on the map.\n\n" +
        "Our SDK also offers the option to pause, resume he download and, when you have it, the option to delete the package.\n\n" +
        "The packages are defined by CARTO's Mobile team and are readily available in our mobile SDK's API."
    
    static let vectorElementsInfoHeader = "VECTOR OBJECTS"
    
    static let vectorElementsInfoContainer =
        "With CARTOMobileSDK you have a convenient way to add different vector elements to your map to spice it up.\n\n" +
        "These are just a few examples of vector elements provided by us. We have a variety of different popups, markers, points, lines, polygons, and models.\n\n" +
        "All elements are also interactive. Go ahead, click on one!\n\n" +
        "In this example, the nml model is a file bundled with the app. NML is CARTO's own compact format for 2D and 3D models.\n\n"
    
    static let clusteringInfoHeader = "VECTOR ELEMENT CLUSTERING"
    
    static let clusteringInfoContainer =
        "" +
        ""
    
    static let gpsLocationInfoHeader = "GPS LOCATION"
    
    static let objectEditingInfoHeader = "VECTOR OBJECT EDITING"
}
