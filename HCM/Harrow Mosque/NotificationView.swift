//
//  NotificationView.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 14/08/2022.
//

import UserNotifications

class NotificationView: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    //MARK: Authorization
    let center = UNUserNotificationCenter.current()
    
    
    //Delegate for UNUserNotificationCenterDelegate
    center.delegate = self
    
    //Permission for request alert, soud and badge
    center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        // Enable or disable features based on authorization.
        if(!granted){
            print("not accept authorization")
        }else{
            print("accept authorization")
            
            center.delegate = self
            
            
        }
    }
    return true
}

}
