//
//  NotificationViewModel.swift
//  PrayerKitBetaTest
//
//  Created by Камиль Зиязетдинов on 28.02.2021.
//

import SwiftUI
import UserNotifications




class NotificationViewModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var sendNotification: Bool {
        didSet {
            UserDefaults.standard.set(sendNotification, forKey: "noti")
        }
    }
        
            override init() {
            self.sendNotification = UserDefaults.standard.object(forKey: "noti") as? Bool ?? false
            super.init()
            UNUserNotificationCenter.current().delegate = self
            
        }
    
     func requestPermission() {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus != .authorized {
                    center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                        if granted {
                            print("Notification authorization success")
                        } else {
                            print("Notification authorization denied")
                        }
                    }
                }
            }
        }
      
    private func getTriggerDate(date: Date, timeIntervalMinutes: Int) -> DateComponents {
        let triggerDate =  date.addingTimeInterval(Double(-timeIntervalMinutes * 60)) // notification will show 1 minute before date
        // return Calendar.current.dateComponents([.timeZone, .year, .month, .day, .hour, .minute], from: triggerDate)

      // notification will show in 10 sec
        return Calendar.current.dateComponents([.timeZone, .year, .month, .day, .hour, .minute, .second], from: triggerDate)
    }
    func scheduleNotification(times: Date) {
        for day in 0...7 {
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "Food Diary Reminder"
            content.body = "Remember to add what you ate for  into your food diary!"
            content.sound = UNNotificationSound.default
            let intervalForDay = Double(60 * 60 * 24 * day)
            let interval = times.addingTimeInterval(intervalForDay)
            let idenficator = UUID().uuidString
         
            
            
      //  let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let triggerDate = getTriggerDate(date: interval, timeIntervalMinutes: 1)
        let trigger = UNCalendarNotificationTrigger(
                    dateMatching: triggerDate,
                    repeats: true)
            
        let request = UNNotificationRequest(identifier: idenficator, content: content, trigger: trigger)
            center.add(request) { (error) in
                if error != nil {
                    print("Could not add notification")
                } else {
                    print("Notification added successfully")
                }
            }
        }
    }
        
        
       func removeNotifications() {
            let center = UNUserNotificationCenter.current()

            center.removeAllPendingNotificationRequests()
        }
        
    

func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner, .badge, .sound])
}

    

}
    
    

