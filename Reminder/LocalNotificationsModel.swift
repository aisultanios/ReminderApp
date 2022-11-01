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
  private let localNotificationsServiceResponce: LocalNotificationsServiceResponce
  
  init(localNotificationsServiceResponce: LocalNotificationsServiceResponce) {
    self.localNotificationsServiceResponce = localNotificationsServiceResponce
  }
    
    func fetchNotifications() {
        
        localNotificationsServiceResponce.fetchUser { notifications in
            
            self.output?.updateView(notifications: notifications)
            
        }
        
    }
  
}
