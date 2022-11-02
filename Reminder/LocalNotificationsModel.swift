//
//  LocalNotificationsModel.swift
//  Reminder
//
//  Created by Aisultan Askarov on 2.11.2022.
//

import UIKit

protocol LocalNotificationsModelOutput: AnyObject {
  func updateView(notifications: [LocalNotifications])
}

class LocalNotificationsModel {
  
  weak var output: LocalNotificationsModelOutput?
  private let localNotificationsService: LocalNotificationsService
  
  init(localNotificationsService: LocalNotificationsService) {
    self.localNotificationsService = localNotificationsService
  }
    
    func fetchNotifications() {
        
        localNotificationsService.fetchUser { notifications in
            
            if notifications.count != 0 {
                self.output?.updateView(notifications: notifications)
            } else if notifications.count == 0 {
                self.output?.updateView(notifications: [LocalNotifications]())
            }
        }
        
    }
  
}
