//
//  Match.swift
//  iwanta
//
//  Created by Meg Sandman on 6/18/15.
//  Copyright (c) 2015 Meg Sandman. All rights reserved.
//

import Foundation

class Match {
    var id:Int = 0
    var name:String = ""
    var link:String = ""
    var address:String = ""
    
    init(id:Int, name:String, link:String) {
        self.id = id
        self.name = name
        self.link = link
    }
}
