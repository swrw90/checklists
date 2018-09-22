//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Seth Watson on 9/14/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import Foundation
class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}

