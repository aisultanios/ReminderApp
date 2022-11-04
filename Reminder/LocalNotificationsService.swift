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
                
                center.getDeliveredNotifications { (deliveredNotifications) in
                    for notification in deliveredNotifications {
                        CoreDataStack.deleteReminder(reminderTitle: notification.request.identifier)
                    }
                    let notificationsList = CoreDataStack().loadUpcomingNotification()
                    completion(notificationsList)
                }
            }
            
        }
        
    }
    
}
