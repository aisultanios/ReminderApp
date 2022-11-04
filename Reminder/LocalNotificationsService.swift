//
//  LocalNotificationsService.swift
//  Reminder
//
//  Created by Aisultan Askarov on 2.11.2022.
//

import UIKit

protocol LocalNotificationsService {
    func fetchNotifications(completion: @escaping ([UNNotificationRequest]) -> Void)
}

class NotificationsApi: LocalNotificationsService {
    
    func fetchNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (notifications) in
            
            print("Count: \(notifications.count)")
            
            if notifications.count == 0 {
                
                completion([UNNotificationRequest]())
                
            } else if notifications.count != 0 {
                
                completion(notifications)
                
            }
            
        }
        
    }
    
}
