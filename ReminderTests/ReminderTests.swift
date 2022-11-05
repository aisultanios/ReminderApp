//
//  ReminderTests.swift
//  ReminderTests
//
//  Created by Aisultan Askarov on 28.10.2022.
//

import XCTest
@testable import Reminder

final class ReminderTests: XCTestCase {

    private var sut: LocalNotificationsModel! //sut - System Under Test
    private var localNotificationsService: MockLocalNotificationsService!
    private var output: MockLocalNotificationsOutput!
    
    override func setUpWithError() throws {
        
        output = MockLocalNotificationsOutput()
        localNotificationsService = MockLocalNotificationsService()
        sut = LocalNotificationsModel(localNotificationsService: localNotificationsService)
        sut.output = output
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        
        sut = nil
        localNotificationsService = nil
        
        try super.tearDownWithError()
    }

    func testExample_whenHasPendingNotifications() throws {
        
        //given
        let contentOfNotification = UNMutableNotificationContent()
        contentOfNotification.title = "Reminder!"
        contentOfNotification.body = "Don't forget to do something"
        contentOfNotification.sound = .default
        contentOfNotification.userInfo = ["date" : Date()]
        
        let fireNotificationDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date(timeIntervalSinceNow: 10000))
        let triggerForNotification = UNCalendarNotificationTrigger(dateMatching: fireNotificationDate, repeats: false)
        
        let notification = UNNotificationRequest(identifier: UUID().uuidString, content: contentOfNotification, trigger: triggerForNotification)
        localNotificationsService.localNotificationMockResult = [notification]
        //when
        sut.fetchNotifications()
        //then
        XCTAssertEqual(output.updateViewArray.count, 1)
        XCTAssertEqual(output.updateViewArray[0].content, contentOfNotification)

    }
    
    func testExample_whenDoesntHavePendingNotifications() throws {
        
        //given
        localNotificationsService.localNotificationMockResult = [UNNotificationRequest]()
        //when
        sut.fetchNotifications()
        //then
        XCTAssertEqual(output.updateViewArray.count, 0)
        
    }
    
}

class MockLocalNotificationsService: LocalNotificationsService {
    
    var localNotificationMockResult: Array<UNNotificationRequest>?
    
    func fetchNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        if let notification = localNotificationMockResult {
            completion(notification)
        }
    }
    
}

class MockLocalNotificationsOutput: LocalNotificationsModelOutput {
    
    var updateViewArray: [UNNotificationRequest] = []
    
    func updateView(notifications: [UNNotificationRequest]) {
        updateViewArray.append(contentsOf: notifications)
    }
    
}
