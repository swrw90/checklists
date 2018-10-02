//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Seth Watson on 9/14/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import Foundation
import UserNotifications

// Defines structure for CheckList Items
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
    
    //Set value of ChecklistItem itemID
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    //Add and remove notifications
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            // 1
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default
            
            // 2
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(
                [.month, .day, .hour, .minute],
                from: dueDate)
            // 3
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false)
            // 4
            let request = UNNotificationRequest(
                identifier: "\(itemID)", content: content,
                trigger: trigger)
            // 5
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Scheduled: \(request) for itemID: \(itemID)")
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(
            withIdentifiers: ["\(itemID)"])
    }
    
    deinit {
        removeNotification()
    }
}
