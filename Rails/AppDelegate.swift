//
//  AppDelegate.swift
//  Rails
//
//  Created by Feng Xinyuan on 17/2/17.
//  Copyright © 2017 nyx. All rights reserved.
//

import UIKit
import UserNotifications
import TTGSnackbar
import PermissionScope
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var wakeTime : Date = Date()        // when did our application wake up most recently?
    var notificationHandler:ViewController?
    var locationTracker:LocationTracker?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("did finish launching with options")
        // Override point for customization after application launch.
        //UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        // Initialising the defaults
        let defaults = UserDefaults.init(suiteName: "group.nauynix.rails")
        // Only for testing
        let totalTimeUsedPerDay: [String: Int] = [:]
        let totalTimeLoggedPerDay: [String: Int] = [:]
        defaults?.set(totalTimeUsedPerDay, forKey: "totalTimeUsedPerDay")
        defaults?.set(totalTimeLoggedPerDay, forKey: "totalTimeLoggedPerDay")
        if defaults?.bool(forKey: "isTracking") == nil{
            defaults?.set(true, forKey: "isTracking")
        }
        if defaults?.double(forKey: "loggedGoal") == nil{
            defaults?.set(0.8, forKey: "loggedGoal")
        }
        defaults?.synchronize()
        
        // Onboarding
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController = sb.instantiateViewController(withIdentifier: "Onboarding")
        
        //Uncomment this to show tutorial everytime
        //defaults?.set(false, forKey: "onboardingComplete")
        
        if (defaults?.bool(forKey: "onboardingComplete"))!{
            initialViewController = sb.instantiateViewController(withIdentifier: "Mainapp")
        }
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        // Prompt the user to allow permissions
        let pscope = PermissionScope()
        if (defaults?.bool(forKey: "onboardingComplete"))!{
            if pscope.statusLocationAlways() == PermissionStatus.authorized && pscope.statusNotifications() == PermissionStatus.authorized{ // Everything is authorized
                notificationHandler = ViewController()
                locationTracker = LocationTracker(params: notificationHandler)
                // Start notifications
                UNUserNotificationCenter.current().delegate = notificationHandler
                // Start 'location' tracking but really just a way to run the app in the background
                locationTracker?.startLocationTracking()
            }
            else{
                // Request them to manage permissions
                let snackbar = TTGSnackbar(message: "Please allow all permissions in settings for the app to work", duration: .middle)
                snackbar.show()
            }
        }

        //let navigationBarAppearace = UINavigationBar.appearance()
        
        //Aesthetic
        /*navigationBarAppearace.barTintColor = UIColor(red:1, green:0.584, blue:0, alpha:1.0)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent*/
        
        // FOR TESTING OF WIDGET ONLY
        /*
        defaults?.set(["BBC", "Facebook", "Instagram", "Quora", "Reddit", "Whatsapp", "Youtube", "Others"], forKey: "selectedAppsString")
        defaults?.set(imageArray: [UIImage(named: "bbc")!, UIImage(named: "facebook")!, UIImage(named: "instagram")!, UIImage(named: "quora")!, UIImage(named: "reddit")!, UIImage(named: "whatsapp")!, UIImage(named: "youtube")!, UIImage(named: "others")!], forKey: "selectedAppsImage")
        defaults?.set(["bbcnewsapp://", "fb://", "instagram://", "quora://", "reddit://", "whatsapp://", "youtube://"], forKey: "selectedAppsURL")*/
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        // time stamp the entering of foreground so we can tell how we got here
        wakeTime = Date()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // ensure the userInfo dictionary has the data you expect
        print("***hello***")
        if let type = userInfo["type"] as? String, type == "status" {
            // IF the wakeTime is less than 1/10 of a second, then we got here by tapping a notification
            print("***whatsup?***")
            if application.applicationState != UIApplicationState.background && Date().timeIntervalSince(wakeTime) < 0.1 {
                // User Tap on notification Started the App
                let snackbar = TTGSnackbar(message: "Try swipping down on the notifications!", duration: .short)
                snackbar.show()
            }
            else {
                // DO stuff here if you ONLY want it to happen when the push arrives
            }
            completionHandler(.newData)
        }
        else {
            completionHandler(.noData)
        }
    }

    /*
    // Support for background fetch
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let tabBarController = window?.rootViewController as? UITabBarController,
            let tabControllers = tabBarController.viewControllers{
            for tabController in tabControllers {
                if let navigationController = tabController as? UINavigationController{
                    if let viewController = navigationController.topViewController as? ViewController{
                        viewController.fetch {
                            viewController.updateUI()
                            completionHandler(.newData)
                            print("background fetch done")
                        }
                    }
                }
            }
        }
        completionHandler(.failed)
    }*/
}

