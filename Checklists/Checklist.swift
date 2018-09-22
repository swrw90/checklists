//
//  Checklist.swift
//  Checklists
//
//  Created by Seth Watson on 9/17/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
    init(name: String) {
        self.name = name
        super.init()
    }
    
    var name = ""
    var items = [ChecklistItem]() 
}
