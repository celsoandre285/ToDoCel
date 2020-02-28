//
//  Item.swift
//  TODOCel
//
//  Created by Celso Lima on 28/02/20.
//  Copyright © 2020 Celso Lima. All rights reserved.
//

import Foundation

class Item {
    var title: String = ""
    var done: Bool = false
    
    init() {}
    
    init(title: String) {
        self.title = title
    }
    
    init(title: String, done: Bool) {
        self.title = title
        self.done  = done
    }
    
}
