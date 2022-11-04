//
//  LocalNotificationsService.swift
//  Reminder
//
//  Created by Aisultan Askarov on 2.11.2022.
//

import UIKit

protocol LocalNotificationsService {
    func fetchUser(completion: @escaping ([LocalNotifications]) -> Void)
}

class CoreDataManager: LocalNotificationsService {
    
    func fetchUser(completion: @escaping ([LocalNotifications]) -> Void) {
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (notifications) in
             
            print("Count: \(notifications.count)")
            
            //If there is no scheduled notifications we will delete data from the context
            if notifications.count == 0 {
                CoreDataStack.deleteContext(entity: "LocalNotifications")
                completion([LocalNotifications]())
            } else if notifications.count != 0 {
                
                var notificationsList = CoreDataStack().loadUpcomingNotification()
                for i in 0..<notificationsList.count {
                    if (notificationsList[i].dateOfUpcomingNotification!) < Date() {
                        CoreDataStack.deleteReminder(reminderTitle: notificationsList[i].title!)
                        notificationsList.remove(at: i)
                    }
                }
                completion(notificationsList)
                
            }
            
        }
        
    }
    
}
