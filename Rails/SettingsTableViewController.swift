//
//  SettingsTableViewController.swift
//  Rails
//
//  Created by Feng Xinyuan on 26/4/17.
//  Copyright © 2017 nyx. All rights reserved.
//

import UIKit
import MessageUI
import PermissionScope
import TTGSnackbar
import UserNotifications

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    let defaults = UserDefaults.init(suiteName: "group.nauynix.rails")
    
    @IBOutlet weak var dailyLogGoalCell: UITableViewCell!
    
    @IBOutlet weak var dailyLogGoal: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var trackingSwitch: UISwitch!
    
    @IBAction func trackingSwitch(_ sender: UISwitch) {
        if sender.isOn{
            dailyLogGoalCell.alpha = 1
            dailyLogGoalCell.isUserInteractionEnabled = true
            defaults?.set(true, forKey: "isTracking")
        }
        else{
            dailyLogGoalCell.alpha = 0.2
            dailyLogGoalCell.isUserInteractionEnabled = false
            defaults?.set(false, forKey: "isTracking")
        }
        
        defaults?.synchronize()
    }
    @IBAction func stepper(_ sender: UIStepper) { // Stepper in daily log goal
        dailyLogGoal.text = "Daily Log Goal: \(String(Int(sender.value*100)))%"
        defaults?.set(sender.value, forKey: "loggedGoal")
        defaults?.synchronize()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        stepper.value = (defaults?.double(forKey: "loggedGoal"))!
        dailyLogGoal.text = "Daily Log Goal: \(String(Int(stepper.value*100)))%"
        trackingSwitch.setOn( (defaults?.bool(forKey: "isTracking"))!, animated: false)
        if trackingSwitch.isOn{
            dailyLogGoalCell.alpha = 1
            dailyLogGoalCell.isUserInteractionEnabled = true
            defaults?.set(true, forKey: "isTracking")
        }
        else{
            dailyLogGoalCell.alpha = 0.2
            dailyLogGoalCell.isUserInteractionEnabled = false
            defaults?.set(false, forKey: "isTracking")
        }
        defaults?.synchronize()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 3{ // Manage Pemissions
            let backgroundColour1 = UIColor(red: 36/255, green: 168/255, blue: 54/255, alpha: 1)
            let defaults = UserDefaults.init(suiteName: "group.nauynix.rails")
            
            let pscope = PermissionScope()
            let notificationHandler = ViewController()
            let locationTracker = LocationTracker(params: notificationHandler)
            // Set up permissions
            pscope.addPermission(NotificationsPermission(notificationCategories: nil),
                                 message: "So that you can decide if you no longer want to use your phone.")
            pscope.addPermission(LocationAlwaysPermission(),
                                 message: "To ensure that the app stays \"alive\" in the background.")
            
            // Set up dialog
            pscope.permissionButtonTextColor = backgroundColour1
            pscope.permissionButtonBorderColor = backgroundColour1
            pscope.headerLabel.text = "Manage Permissions"
            pscope.bodyLabel.text = "Please allow both permissions for the app to work."
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
                }
                else{
                    // Request them to manage permissions
                    let snackbar = TTGSnackbar(message: "Please allow all permissions in settings for the app to work", duration: .middle)
                    snackbar.show()
                }
            }, cancelled: { (results) -> Void in
                print("thing was cancelled")// Request them to manage permissions
                let snackbar = TTGSnackbar(message: "Please allow all permissions in settings for the app to work", duration: .middle)
                snackbar.show()
            })
            if pscope.statusLocationAlways() == PermissionStatus.authorized && pscope.statusNotifications() == PermissionStatus.authorized{ // Everything is authorized
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            
        }
        if indexPath.section == 1 && indexPath.row == 4{ // Contact Us
            let mailComposeViewController = configuredMailComposeViewController(subject: "")
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
    }
    
    @IBAction func changeReminders(_ sender: UISwitch) {
        defaults?.set(sender.isOn, forKey: "sendReminders")
        defaults?.synchronize()
    }
    
    // Mail
    func configuredMailComposeViewController(subject:String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["troppussliar@gmail.com"])
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
