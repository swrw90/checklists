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
        handleFirstTime()
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
        let dictionary: [String:Any] = [ "ChecklistIndex": -1,
                                         "FirstTime": true ]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
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
                sortChecklists() 
            } catch {
                print("Error decoding item array!")
            }
        }
    }
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(
                forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: "ChecklistIndex")
        }
    }
    
    func sortChecklists() {
        lists.sort(by: { checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(
                checklist2.name) == .orderedAscending })
    }
}
