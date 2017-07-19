//
//  ViewController.swift
//  Rails
//
//  Created by Feng Xinyuan on 15/2/17.
//  Copyright © 2017 nyx. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController{// I know it says its a ViewController but it is really just a notification handler
    let defaults = UserDefaults.init(suiteName: "group.nauynix.rails")
    
    //MARK: Properties
    var isGrantedNotificationAccess:Bool = false
    static private var previousUnlockedPhoneDate = Date()
    static private var previousLoggedDate = Date() // The date that the user has started the timer
    static private var deviceIsLocked = false
    static private var totalTimeUsedPerDay: [String: Int] = [:]
    static private var totalTimeLoggedPerDay: [String: Int] = [:] // The uptime when the widget timer is running ie. the uptime that is logged and the user is aware that he is using the phone
    static private var first = true
    static private var secondsSincePhoneWasOn = 0 // Use the update method to count the seconds since the phone was turned on. When it reaches 30, the unlocked notification is called to notify the user to set a timer.
    /*
     private lazy var locationManager: CLLocationManager = {
     let manager = CLLocationManager()
     manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
     manager.distanceFilter = 99999
     manager.delegate = self
     manager.requestAlwaysAuthorization()
     manager.pausesLocationUpdatesAutomatically = false
     return manager
     }()*/
    
    //MARK: Initialisation
    /*
     convenience init() {
     self.init()
     UNUserNotificationCenter.current().delegate = self
     UNUserNotificationCenter.current().requestAuthorization(options:
     [[.alert, .sound, .badge]], completionHandler: {(granted, error) in self.isGrantedNotificationAccess = granted})
     print("hello! from notification handler")
     }
     
     required init?(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
     }*/
    
    //MARK: Action
    @objc
    func unlocked(){
        ViewController.previousUnlockedPhoneDate = Date()
        ViewController.deviceIsLocked = false
        ViewController.secondsSincePhoneWasOn = 0
    }
    
    @objc
    func update(){
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers:
                ["request", "unlocked"])
        if defaults?.integer(forKey: "timeSetInMinutes") != nil && defaults?.object(forKey: "timerStartedDate") != nil{
            let timeLeftInSeconds = (defaults?.integer(forKey: "timeSetInMinutes"))! * 60 + Int(round(((defaults?.object(forKey: "timerStartedDate") as? Date)?.timeIntervalSinceNow)!))
            print("Time left in seconds: \(timeLeftInSeconds)")
            if (defaults?.bool(forKey: "notificationIsNotSent"))! && timeLeftInSeconds == 1{
                ViewController.previousLoggedDate = Date()
                sendNotifications(timeIntervalInSeconds: timeLeftInSeconds)
                defaults?.set(false, forKey: "notificationIsNotSent")
            }
        }
        ViewController.secondsSincePhoneWasOn += 1
        if ViewController.secondsSincePhoneWasOn == 30 {
            setUnlockedNotification()
            ViewController.secondsSincePhoneWasOn = -31540000
        }
    }
    
    
    @objc
    func locked(){
        if ViewController.deviceIsLocked == false{ // The locked function is called around 10 times everytime the phone is locked so a boolean is checked to make sure that the uptime is not counted again
            
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current()
                .removePendingNotificationRequests(withIdentifiers:
                    ["request", "unlocked"])
            ViewController.secondsSincePhoneWasOn = -31540000
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            
            ViewController.totalTimeUsedPerDay = (defaults?.object(forKey: "totalTimeUsedPerDay") as? [String:Int])!
            ViewController.totalTimeLoggedPerDay = (defaults?.object(forKey: "totalTimeLoggedPerDay") as? [String:Int])!
            
            if ViewController.totalTimeUsedPerDay[dateFormatter.string(from: ViewController.previousUnlockedPhoneDate)] == nil{ // Initialise
                ViewController.totalTimeUsedPerDay[dateFormatter.string(from: ViewController.previousUnlockedPhoneDate)] = 0
            }
            
            if ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: ViewController.previousLoggedDate)] == nil{ // Initialise
                ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: ViewController.previousLoggedDate)] = 0
            }
            
            if ViewController.totalTimeUsedPerDay[dateFormatter.string(from: Date())] == nil{ // Initialise
                ViewController.totalTimeUsedPerDay[dateFormatter.string(from: Date())] = 0
            }
            
            if ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: Date())] == nil{ // Initialise
                ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: Date())] = 0
            }
            
            // Add time interval between phone unlocked to now
            ViewController.totalTimeUsedPerDay[dateFormatter.string(from: ViewController.previousUnlockedPhoneDate)]! -= Int(ViewController.previousUnlockedPhoneDate.timeIntervalSinceNow)
            
            if (defaults?.integer(forKey: "timeSetInMinutes"))! * 60 != 0{ // Phone is locked in the middle of an active timer
                ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: ViewController.previousLoggedDate)]! -= (defaults?.integer(forKey: "timeSetInMinutes"))! * 60
                ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: ViewController.previousLoggedDate)]! -= Int(ViewController.previousLoggedDate.timeIntervalSinceNow)
            }
            
            if dateFormatter.string(from: ViewController.previousUnlockedPhoneDate) != dateFormatter.string(from: Date()){ // It is a new day!
                let secondsFromMidnightToNow = -Int(Calendar.current.startOfDay(for: Date()).timeIntervalSinceNow)
                ViewController.totalTimeUsedPerDay[dateFormatter.string(from: Date())] = secondsFromMidnightToNow
                ViewController.totalTimeUsedPerDay[dateFormatter.string(from: ViewController.previousUnlockedPhoneDate)]! -= secondsFromMidnightToNow
                
                if (defaults?.integer(forKey: "timeSetInMinutes"))! * 60 != 0{ // Phone is locked in the middle of an active timer
                    ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: Date())] = secondsFromMidnightToNow
                    ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: ViewController.previousLoggedDate)]! -= secondsFromMidnightToNow
                }
                else{
                    ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: Date())] = 0
                }
            }
            
            /*
             if ViewController.totalTimeUsedPerDay[dateFormatter.string(from: ViewController.previousUnlockedPhoneDate)] != nil{ // Add time interval between phone unlocked to now
             ViewController.totalTimeUsedPerDay[dateFormatter.string(from: ViewController.previousUnlockedPhoneDate)]! -= Int(ViewController.previousUnlockedPhoneDate.timeIntervalSinceNow)
             }
             else{
             ViewController.totalTimeUsedPerDay[dateFormatter.string(from: ViewController.previousUnlockedPhoneDate)] = -Int(ViewController.previousUnlockedPhoneDate.timeIntervalSinceNow)
             }
             if (defaults?.integer(forKey: "timeSetInMinutes"))! * 60 != 0{ // Phone is locked in the middle of an active timer
             if ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: ViewController.previousLoggedDate)] != nil{
             ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: ViewController.previousLoggedDate)]! -= (defaults?.integer(forKey: "timeSetInMinutes"))! * 60
             ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: ViewController.previousLoggedDate)]! -= Int(ViewController.previousLoggedDate.timeIntervalSinceNow)
             }
             else{
             ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: ViewController.previousLoggedDate)] = -Int(ViewController.previousUnlockedPhoneDate.timeIntervalSinceNow) - (defaults?.integer(forKey: "timeSetInMinutes"))! * 60
             }
             }
             
             if dateFormatter.string(from: ViewController.previousUnlockedPhoneDate) != dateFormatter.string(from: Date()){ // It is a new day!
             let secondsFromMidnightToNow = -Int(Calendar.current.startOfDay(for: Date()).timeIntervalSinceNow)
             ViewController.totalTimeUsedPerDay[dateFormatter.string(from: Date())] = secondsFromMidnightToNow
             ViewController.totalTimeUsedPerDay[dateFormatter.string(from: ViewController.previousUnlockedPhoneDate)]! -= secondsFromMidnightToNow
             
             if (defaults?.integer(forKey: "timeSetInMinutes"))! * 60 != 0{ // Phone is locked in the middle of an active timer
             ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: Date())] = secondsFromMidnightToNow
             ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: ViewController.previousLoggedDate)]! -= secondsFromMidnightToNow
             }
             else{
             ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: Date())] = 0
             }
             }*/
            defaults?.set(ViewController.totalTimeUsedPerDay, forKey: "totalTimeUsedPerDay")
            defaults?.set(ViewController.totalTimeLoggedPerDay, forKey: "totalTimeLoggedPerDay")
            defaults?.removeObject(forKey: "timerStartedDate")
            ViewController.deviceIsLocked = true
            print("***********************")
            print("UPTIME SO FAR: \(String(describing: ViewController.totalTimeUsedPerDay[dateFormatter.string(from: Date())]))")
            print("LOGGED UPTIME SO FAR: \(String(describing: ViewController.totalTimeLoggedPerDay[dateFormatter.string(from: Date())]))")
            print("***********************")
            
            defaults?.set(0, forKey: "timeSetInMinutes")
            print(defaults?.integer(forKey: "timeSetInMinutes"))
        }
    }
    
    func sendNotifications(timeIntervalInSeconds: Int){
        print("******************\n\(isGrantedNotificationAccess)\n*******************")
        
        if (ViewController.first){ // First time this is run
            UNUserNotificationCenter.current().delegate = self
            ViewController.first = false
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                self.isGrantedNotificationAccess = granted
            }
        }
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized && timeIntervalInSeconds > 0{ // timeIntervalInSeconds = 0 during initialisation
                // Notifications allowed
                //Set the content of the notification
                let content = UNMutableNotificationContent()
                let messageSubtitle = "It is time to stop using your phone"
                content.body = messageSubtitle
                
                //let responseAction = UNTextInputNotificationAction(identifier: "response", title: "Reply", options: [], textInputButtonTitle: "Let's go!", textInputPlaceholder: "Reason")
                let snoozeFor2MinAction = UNNotificationAction(identifier: "2min", title: "Snooze for 2 mins", options: [])
                let snoozeFor5MinAction = UNNotificationAction(identifier: "5min", title: "Snooze for 5 mins", options: [])
                let snoozeFor10MinAction = UNNotificationAction(identifier: "10min", title: "Snooze for 10 mins", options: [])
                let snoozeFor20MinAction = UNNotificationAction(identifier: "20min", title: "Snooze for 20 mins", options: [])
                
                let category = UNNotificationCategory(identifier: "responseCategory", actions: [snoozeFor2MinAction, snoozeFor5MinAction, snoozeFor10MinAction, snoozeFor20MinAction], intentIdentifiers: [], options: [])
                
                content.categoryIdentifier = "responseCategory"
                
                UNUserNotificationCenter.current().setNotificationCategories([category])
                //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeIntervalInSeconds), repeats: false)
                //var trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(120), repeats: false)
                //var request = UNNotificationRequest(identifier: "request", content: content, trigger: trigger)
                
                //content.sound = UNNotificationSound(named: "silent.wav")
                
                //UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
                print("******************\nSent notification\n*******************")
                
                var trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(0.5), repeats: false)
                var request = UNNotificationRequest(identifier: "request", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)/*
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(60), repeats: false)
                request = UNNotificationRequest(identifier: "request", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(90), repeats: false)
                request = UNNotificationRequest(identifier: "request", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(120), repeats: false)
                request = UNNotificationRequest(identifier: "request", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)*/
            }
        }
    }
    
    func setUnlockedNotification(){ // Bug the user to set a timer if he has not after a minute of opening the phone
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized{ // timeIntervalInSeconds = 0 during initialisation
                // Notifications allowed
                //Set the content of the notification
                let content = UNMutableNotificationContent()
                let messageSubtitle = "Set a timer to monitor your phone usage"
                content.body = messageSubtitle
                
                //let responseAction = UNTextInputNotificationAction(identifier: "response", title: "Reply", options: [], textInputButtonTitle: "Let's go!", textInputPlaceholder: "Reason")
                let snoozeFor2MinAction = UNNotificationAction(identifier: "2min", title: "2 mins", options: [])
                let snoozeFor5MinAction = UNNotificationAction(identifier: "5min", title: "5 mins", options: [])
                let snoozeFor10MinAction = UNNotificationAction(identifier: "10min", title: "10 mins", options: [])
                let snoozeFor20MinAction = UNNotificationAction(identifier: "20min", title: "20 mins", options: [])
                
                let category = UNNotificationCategory(identifier: "responseCategory", actions: [snoozeFor2MinAction, snoozeFor5MinAction, snoozeFor10MinAction, snoozeFor20MinAction], intentIdentifiers: [], options: [])
                
                content.categoryIdentifier = "responseCategory"
                
                UNUserNotificationCenter.current().setNotificationCategories([category])
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(0.5), repeats: false)
                let request = UNNotificationRequest(identifier: "unlocked", content: content, trigger: trigger)
                
                //content.sound = UNNotificationSound(named: "silent.wav")
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
            }
        }
    }
}

extension ViewController:UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "2min":
            print("Set timer to two minutes")
            defaults?.set(2, forKey: "timeSetInMinutes")
            sendNotifications(timeIntervalInSeconds: 120)
        case "5min":
            print("Set timer to five minutes")
            defaults?.set(5, forKey: "timeSetInMinutes")
            sendNotifications(timeIntervalInSeconds: 300)
        case "10min":
            print("Set timer to ten minutes")
            defaults?.set(10, forKey: "timeSetInMinutes")
            sendNotifications(timeIntervalInSeconds: 600)
        case "20min":
            print("Set timer to twenty minutes")
            defaults?.set(20, forKey: "timeSetInMinutes")
            sendNotifications(timeIntervalInSeconds: 1200)
        default:
            break
        }
        defaults?.set(Date(), forKey: "timerStartedDate")
        print(defaults?.integer(forKey: "timeSetInMinutes"))
        completionHandler()
    }

}
/*
 // MARK: - CLLocationManagerDelegate
 extension ViewController: CLLocationManagerDelegate {
 
 func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
 guard let _ = locations.last else {
 return
 }
 //print("App is backgrounded. New location is %@", mostRecentLocation)
 }
 
 }
 
 let instagramHooks = "whatsapp://app"
 let instagramUrl = URL(string: instagramHooks)
 if UIApplication.shared.canOpenURL(instagramUrl! as URL)
 {
 UIApplication.shared.open(instagramUrl!)
 
 }
 UIApplication.shared.open(instagramUrl!)
 //sendNotifications()
 let dateComponentsFormatter = DateComponentsFormatter()
 dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfYear,.day,.hour,.minute,.second]
 dateComponentsFormatter.maximumUnitCount = 1
 dateComponentsFormatter.unitsStyle = .full
 print(dateComponentsFormatter.string(from: lastDate, to: Date())!)
 var lastUsed = dateComponentsFormatter.string(from: lastDate, to: Date())!
 */
