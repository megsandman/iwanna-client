//
//  City.swift
//  iwanta
//
//  Created by Meg Sandman on 6/24/15.
//  Copyright (c) 2015 Meg Sandman. All rights reserved.
//

import Foundation

class City {
    var id:Int = 0
    var name:String = ""
    var image:String = ""
    
    init(name:String, image:String) {
        self.name = name
        self.image = image
    }
    
}