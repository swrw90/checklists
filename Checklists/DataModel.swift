//
//  DataModel.swift
//  Checklists
//
//  Created by Seth Watson on 9/21/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
        registerDefaults()
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent(
            "Checklists.plist")
    }
    
    // This creates a new Dictionary instance and adds the value -1 for the key “ChecklistIndex”
    
    func registerDefaults() {
        let dictionary = [ "ChecklistIndex": -1 ]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    // this method is now called saveChecklists()
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            // You encode lists instead of "items”
            
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(),
                           options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array!")
        }
    }
    
    // this method is now called loadChecklists()
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                // You decode to an object of [Checklist] type to lists
                lists = try decoder.decode([Checklist].self, from: data)
            } catch {
                print("Error decoding item array!")
            }
        }
    }
}
