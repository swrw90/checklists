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
    
    //Notification setup and identifier
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    func toggleChecked() {
        checked = !checked
    }
    
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
}

