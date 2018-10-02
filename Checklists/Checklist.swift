//
//  Checklist.swift
//  Checklists
//
//  Created by Seth Watson on 9/17/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

/// Define structure for Checklist including count of checked items, icon for list and array of list items
class Checklist: NSObject, Codable {
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    var name = ""
    var items = [ChecklistItem]()
    var iconName = "No Icon"
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        
        return count
    }
}
