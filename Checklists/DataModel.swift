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
        //FileManager looks for a Documents directory in userDomainMask and returns array of urls as path to documents directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        //returns string url file path to xml list object of saved checklists to be loaded
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    // This creates a new Dictionary instance and adds the value -1 for the key “ChecklistIndex”
    
    func registerDefaults() {
        //initial value of checklistIndex will be set to 0 on first load to view initial List
        let dictionary: [String:Any] = [ "ChecklistIndex": -1,
                                         "FirstTime": true ]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        //looks for bool on userDefaults with key firstTime
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            //creates initial Checklist
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            //set index of selected checklist
            indexOfSelectedChecklist = 0
            //change userDefaults bool for firstTime to false
            userDefaults.set(false, forKey: "FirstTime")

        }
    }
    
    // this method is now called saveChecklists()
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            // Encode lists instead of "items”
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array!")
        }
    }
    
    // this method is now called loadChecklists()
    func loadChecklists() {
        let path = dataFilePath()
        //if data fails to initialize return nil, data success assign xml
        if let data = try? Data(contentsOf: path) {
            //decodes data, plist in this case
            let decoder = PropertyListDecoder()
            do {
                // Decode to an object of [Checklist] type to lists
                lists = try decoder.decode([Checklist].self, from: data)
                sortChecklists() 
            } catch {
                print("Error decoding item array!")
            }
        }
    }
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    func sortChecklists() {
        //sort array of checklists by name
        lists.sort(by: { checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending })
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
}
