//
//  Languages.swift
//  Feature Demo
//
//  Created by Aare Undo on 20/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class Languages {
    
    static var list = [Language]()
    
    static func initialize() {
        
        var language = Language()
        language.name = "Default"
        language.value = ""
        
        list.append(language)
        
        language = Language()
        language.name = "English"
        language.value = "en"
        
        list.append(language)
        
        language = Language()
        language.name = "German"
        language.value = "de"
        
        list.append(language)
        
        language = Language()
        language.name = "Spanish"
        language.value = "es"
        
        list.append(language)
        
        language = Language()
        language.name = "Italian"
        language.value = "it"
        
        list.append(language)
        
        language = Language()
        language.name = "French"
        language.value = "fr"
        
        list.append(language)
        
        language = Language()
        language.name = "Russian"
        language.value = "ru"
        
        list.append(language)
    }
}

class Language : NSObject {
    
    var name: String!
    
    var value: String!
}





