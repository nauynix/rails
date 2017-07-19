//
//  AppDelegate.swift
//  Rails
//
//  Created by Feng Xinyuan on 17/2/17.
//  Copyright © 2017 nyx. All rights reserved.
//

import UIKit
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
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
        
        // Start 'location' tracking but really just a way to run the app in the background
        // Make and store a copy of ViewController
        let viewController = ViewController()
        viewController.sendNotifications(timeIntervalInSeconds: 0)
        let locationTracker:LocationTracker = LocationTracker(params: viewController)
        locationTracker.startLocationTracking()
        //Send the best location to server every 60 seconds
        //You may adjust the time interval depends on the need of your app.
        var _ = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { (Timer) in
            locationTracker.updateLocationToServer()
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
        /*
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var vc:ViewController
        
        //vc = storyBoard.instantiateViewController(withIdentifier: "")
        vc = storyBoard.instantiateInitialViewController()! as! ViewController
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()*/
        
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

