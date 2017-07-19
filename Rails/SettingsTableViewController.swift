//
//  SettingsTableViewController.swift
//  Rails
//
//  Created by Feng Xinyuan on 26/4/17.
//  Copyright © 2017 nyx. All rights reserved.
//

import UIKit
import MessageUI

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
    }
    @IBAction func stepper(_ sender: UIStepper) { // Stepper in daily log goal
        dailyLogGoal.text = "Daily Log Goal: \(String(Int(sender.value*100)))%"
        defaults?.set(sender.value, forKey: "loggedGoal")
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
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 4{ // Contact Us
            let mailComposeViewController = configuredMailComposeViewController(subject: "")
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
    }
    
    // Mail
    func configuredMailComposeViewController(subject:String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
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
