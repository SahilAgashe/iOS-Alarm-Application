//
//  LocalNotification.swift
//  Alarm-System
//
//  Created by Sahil Agashe on 01/04/23.
//

import UIKit
import UserNotifications

class LocalNotification {
    
    var notificationIdentifier: String?
    var content: UNNotificationContent?
    var trigger: UNNotificationTrigger?
    var title: String?
    var body: String?
    var dateComponents: DateComponents?
    var isSnooze: Bool?
    var alarmTimeString: String?
    var date: Date?
    
    init(notificationIdentifier: String, content: UNNotificationContent, trigger: UNNotificationTrigger, date: Date)
    {
        self.notificationIdentifier = notificationIdentifier
        self.content = content
        self.trigger = trigger
        self.date = date
        self.title = content.title
        self.body = content.body
        self.isSnooze = trigger.repeats
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM y, HH:mm a"
        self.alarmTimeString = dateFormatter.string(from: date)
    }
    
    // empty initializer
    init()
    {
        
    }
    
    func updateNotification(newContent: UNNotificationContent, newTrigger:UNNotificationTrigger, newDate: Date) {
        content = newContent
        trigger = newTrigger
        date = newDate
        
        title = content?.title
        body = content?.body
        isSnooze = trigger?.repeats
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM y, HH:mm a"
        alarmTimeString = dateFormatter.string(from: date ?? Date())
    }
    
}
