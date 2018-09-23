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
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}
