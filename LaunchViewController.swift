//
//  LaunchViewController.swift
//  Rails
//
//  Created by Feng Xinyuan on 19/7/17.
//  Copyright © 2017 nyx. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import paper_onboarding
import PermissionScope
import UserNotifications
import TTGSnackbar

class LaunchViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate{
    @IBOutlet weak var videoPreviewLayer: UIView!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var onboardingView: OnboardingView!
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    let backgroundColour1 = UIColor(red: 36/255, green: 168/255, blue: 54/255, alpha: 1)
    let backgroundColour2 = UIColor(red: 15/255, green: 135/255, blue: 100/255, alpha: 1)
    let backgroundColour3 = UIColor(red: 67/255, green: 110/255, blue: 97/255, alpha: 1)
    let backgroundColour4 = UIColor(red: 130/255, green: 60/255, blue: 113/255, alpha: 1)
    let backgroundColour5 = UIColor(red: 96/255, green: 12/255, blue: 110/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStartedButton.layer.borderWidth = 1
        getStartedButton.layer.borderColor = UIColor.white.cgColor
        getStartedButton.layer.cornerRadius = 6;
        onboardingView.dataSource = self
        onboardingView.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
 
    func onboardingItemsCount() -> Int {
        return 9
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let titleFont = UIFont.init(name: "AvenirNext-DemiBold", size: 30)
        let descriptionFont = UIFont.init(name: "AvenirNext-Regular", size: 17)
        // Timer icon
        // Filled timer icon
        // Rocket icon
        // Screenshot of widget
        // Notification
        // White line chart
        
        return [
             ("Transparent background app icon v2.5","Rails","Keeping your phone use on track","",backgroundColour1,UIColor.white,UIColor.white,titleFont,descriptionFont),
             
             ("empty timer","A 1 min tutorial","Have you ever opened an app thinking you will only use it for a few minutes?","",backgroundColour2,UIColor.white,UIColor.white,titleFont,descriptionFont),
             
             ("full timer","Not again!","...and turn off your phone after hours have passed?","",backgroundColour3,UIColor.white,UIColor.white,titleFont,descriptionFont),
             
             ("rocket","Control","With Rails, you plan for how long you want to use your phone and when you want to stop.","",backgroundColour4,UIColor.white,UIColor.white,titleFont,descriptionFont),
             
             ("","Widget","Place your app in the widget and access it from the homescreen.\n\nPress and hold down an app icon to set the time you can use the app","",backgroundColour5,UIColor.white,UIColor.white,titleFont,descriptionFont),
             
             ("","Notification","When the timer is up, you will receive a notification from us to stop using the phone.\n\nWrap up and stop using the app.","",backgroundColour4,UIColor.white,UIColor.white,titleFont,descriptionFont),
             
             ("target","Empower yourself","With Rails, you make each continual use of deliberate.\nEvery time you shut off your phone, you regain control of your time.","",backgroundColour3,UIColor.white,UIColor.white,titleFont,descriptionFont),
             
             ("growth","Analyse","At the end of the day, analysis will show you your amount of phone usage (coming soon)","",backgroundColour2,UIColor.white,UIColor.white,titleFont,descriptionFont),
            
            ("timeglass","Delayed gratification","Encourages you to think if you really want to use the app instead of launching it out of habit (coming soon)","",backgroundColour1,UIColor.white,UIColor.white,titleFont,descriptionFont)
            
            ][index] as! OnboardingItemInfo
        
        /*
         ("empty timer","1 min tutorial","Have you ever opened a app thinking you will only use it for a few minutes?","",backgroundColour1,UIColor.white,UIColor.white,titleFont,descriptionFont),
         
         ("full timer","Not again!","...and turn off your phone after hours have passed?","",backgroundColour2,UIColor.white,UIColor.white,titleFont,descriptionFont),
         
         ("rocket","No distraction","Our app aims to make you conscious of your actions on your phone","",backgroundColour3,UIColor.white,UIColor.white,titleFont,descriptionFont),
         
         ("","Widget","1) Set your most frequently used apps and access it from our widget\n2) Hold down the app to set a timer\n3) You can set an unlimited amount of timer across the day","",backgroundColour4,UIColor.white,UIColor.white,titleFont,descriptionFont),
         
         ("","Take control","When the timer is up, we will remind you to stop using your phone (but you can continue to use it if you want)","",backgroundColour5,UIColor.white,UIColor.white,titleFont,descriptionFont),
         
         ("growth","Analyse","At the end of the day, analysis will show you the amount of phone usage that is logged with the timer (coming soon)","",backgroundColour6,UIColor.white,UIColor.white,titleFont,descriptionFont)*/
        
        /*return [("","No more distraction","Have you ever fallen into the rabbit hole of social media intending to briefly check out the news but end up scrolling for hours? So do we.","",backgroundColour,UIColor.white,UIColor.white,titleFont,descriptionFont), ("","Add Widgets","Select up to 7 most commonly used apps and add our widget to the widget list","",backgroundColour,UIColor.white,UIColor.white,titleFont,descriptionFont), ("","Train your focus","Access your apps by swiping left on the lockscreen and holding the app down until the desired timer pops up","",backgroundColour,UIColor.white,UIColor.white,titleFont,descriptionFont), ("","Ding Dong!","We will send you your notification when the timer runs out so you know when to stop using your phone","",backgroundColour,UIColor.white,UIColor.white,titleFont,descriptionFont), ("linechart","Analyse","Monitor your phone usage to be conscious of how much you use it (coming soon)","",backgroundColour,UIColor.white,UIColor.white,titleFont,descriptionFont)][index] as! OnboardingItemInfo*/
    }
        //(imageName: String, title: String, description: String, iconName: String, color: UIColor, titleColor: UIColor, descriptionColor: UIColor, titleFont: UIFont, descriptionFont: UIFont)

    func onboardingDidTransitonToIndex(_ index: Int) {
        // Show get started button at last page
        if index == 8{
            UIView.animate(withDuration: 0.25, animations: {
                self.getStartedButton.alpha = 1
            })
        }
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        // Show video on 5th page
        if index == 4{
            let moviePath = Bundle.main.path(forResource: "Widget 1 v1.6", ofType: "mp4")
            if let path = moviePath {
                self.avpController.removeFromParentViewController()
                self.avpController.view.removeFromSuperview()
                let url = NSURL.fileURL(withPath: path)
                self.player = AVPlayer(url: url)
                self.avpController = AVPlayerViewController()
                self.avpController.player = self.player
                avpController.view.frame = videoPreviewLayer.frame
                NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
                    self.player.seek(to: kCMTimeZero)
                    self.player.play()
                }
                self.avpController.showsPlaybackControls = false
                self.addChildViewController(self.avpController)
                self.view.addSubview(avpController.view)
                avpController.view.layer.masksToBounds = true
                avpController.view.layer.cornerRadius = 13
                self.avpController.view.alpha = 0
                UIView.animate(withDuration: 0.25, animations: {
                    self.avpController.view.alpha = 1
                })
                self.player.play()
            }
        }
        // Show video on 6th page
        else if index == 5{
            let moviePath = Bundle.main.path(forResource: "Widget 2 v1", ofType: "mp4")
            if let path = moviePath {
                self.avpController.removeFromParentViewController()
                self.avpController.view.removeFromSuperview()
                let url = NSURL.fileURL(withPath: path)
                self.player = AVPlayer(url: url)
                self.avpController = AVPlayerViewController()
                self.avpController.player = self.player
                avpController.view.frame = videoPreviewLayer.frame
                NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
                    self.player.seek(to: kCMTimeZero)
                    self.player.play()
                }
                self.avpController.showsPlaybackControls = false
                self.addChildViewController(self.avpController)
                self.view.addSubview(avpController.view)
                avpController.view.layer.masksToBounds = true
                avpController.view.layer.cornerRadius = 13
                self.avpController.view.alpha = 0
                UIView.animate(withDuration: 0.25, animations: {
                    self.avpController.view.alpha = 1
                })
                self.player.play()
            }
        }
        // Hide video if not 5th or 6th page
        else {
            UIView.animate(withDuration: 0.25, animations: {
                self.avpController.view.alpha = 0
            })
            self.avpController.removeFromParentViewController()
            self.avpController.view.removeFromSuperview()
        }
        // Hide button if not last page
        if index != 8{
            UIView.animate(withDuration: 0.25, animations: {
                self.getStartedButton.alpha = 0
            })
        }
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
    }
    
    @IBAction func getStarted(_ sender: Any) {
        let notificationHandler = ViewController()
        let locationTracker = LocationTracker(params: notificationHandler)
        let pscope = PermissionScope()
        let defaults = UserDefaults.init(suiteName: "group.nauynix.rails")
        
        // Set up permissions
        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
                             message: "So that you can decide if you no longer want to use your phone.")
        pscope.addPermission(LocationAlwaysPermission(),
                             message: "To ensure that the app stays \"alive\" in the background.")
        
        // Set up dialog
        pscope.permissionButtonTextColor = backgroundColour1
        pscope.permissionButtonBorderColor = backgroundColour1
        pscope.headerLabel.text = "Congratulations!"
        pscope.bodyLabel.text = "We need a couple things to get you started."
        pscope.closeButton.setTitleColor(backgroundColour1, for: .normal)
        pscope.headerLabel.font = UIFont.init(name: "AvenirNext-DemiBold", size: 20)!
        pscope.bodyLabel.font = UIFont.init(name: "AvenirNext-Regular", size: 17)!
        pscope.buttonFont = UIFont.init(name: "AvenirNext-Regular", size: 14)!
        pscope.labelFont = UIFont.init(name: "AvenirNext-Regular", size: 14)!
        // Show dialog with callbacks
        pscope.show({ finished, results in
            print("got results \(results)")
            if results[0].status == PermissionStatus.authorized && results[1].status == PermissionStatus.authorized{
                // Start notifications
                UNUserNotificationCenter.current().delegate = notificationHandler
                
                // Start 'location' tracking but really just a way to run the app in the background
                locationTracker?.startLocationTracking()
                
                // Show snackbar to tell the user to go to the homescreen, swipe left and add widget
                let snackbar = TTGSnackbar(message: "Swipe left on homescreen until the widgets page and add our widget \"Rails\"",
                                           duration: .forever,
                                           actionText: "Close",
                                           actionBlock: { (snackbar) in
                                            snackbar.dismiss()
                })
                snackbar.actionTextColor = self.backgroundColour1
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                    snackbar.show()
                }
            }
            else{
                /*
                let snackbar = TTGSnackbar(message: "Please allow all permissions in settings for the app to work", duration: .middle)
                snackbar.show()*/
            }
        }, cancelled: { (results) -> Void in
            print("thing was cancelled")
            // Request them to manage permissions
            let snackbar = TTGSnackbar(message: "Please allow all permissions in settings for the app to work", duration: .middle)
            snackbar.show()
        })
        defaults?.set(true, forKey: "sendReminders")
        defaults?.set(true, forKey: "onboardingComplete")
        defaults?.synchronize()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
