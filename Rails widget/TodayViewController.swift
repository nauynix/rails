//
//  TodayViewController.swift
//  Rails widget
//
//  Created by Feng Xinyuan on 17/2/17.
//  Copyright © 2017 nyx. All rights reserved.
//

import UIKit
import NotificationCenter
import UserNotifications
import AudioToolbox

extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let newLength = self.characters.count
        if newLength < toLength {
            return String(repeatElement(character, count: toLength - newLength)) + self
        } else {
            return self.substring(from: index(self.startIndex, offsetBy: newLength - toLength))
        }
    }
}

class TodayViewController: UIViewController, NCWidgetProviding{
    //MARK: Properties
    static private var timerStartedDate = Date()
    static private var timerHasStarted = false
    static private var timerForSettingTimer, timerForCountingDown: Timer?
    static private var timeSetInMinutes = 0
    
    // To mark out where the objects should return to
    static private var progressViewInitialX: CGFloat = 0
    static private var resetButtonInitialX: CGFloat = 0
    static private var timeLeftLabelInitialX: CGFloat = 0
    static private var progressViewFinalX: CGFloat = 0
    static private var resetButtonFinalX: CGFloat = 0
    static private var timeLeftLabelFinalX: CGFloat = 0
    static private var buttonSelected:Int = 1
    private var minimumAllowedMovements = 5
    private var buttonState = 0 // 0 is nothing, 1 is began, 2 is ended, 3 is cancelled
    
    private let timeInteverals = [2, 5, 10, 20, 60]
    private let timeIsUpString = "Time to stop using your phone!"
    private let defaultRed:CGFloat = 1
    private let defaultGreen:CGFloat = 1
    private let defaultBlue:CGFloat = 1
    private let defaultAlpha:CGFloat = 1
    private let appSize:CGFloat = 60
    private var stackSpacing:CGFloat = 0
    
    /*private let appNameArray: [String] = ["BBC", "Facebook", "Instagram", "Quora", "Reddit", "Whatsapp", "Youtube"]
    private let appImageArray: [UIImage] = [UIImage(named: "bbc")!, UIImage(named: "facebook")!, UIImage(named: "instagram")!, UIImage(named: "quora")!, UIImage(named: "reddit")!, UIImage(named: "whatsapp")!, UIImage(named: "youtube")!]
    private let appUrlArray: [URL] = [URL(string: "bbcnewsapp://")!, URL(string: "fb://")!, URL(string: "instagram://")!, URL(string: "quora://")!, URL(string: "reddit://")!, URL(string: "whatsapp://")!, URL(string: "youtube://")!]*/
    private var appNameArray: [String] = []
    private var appImageArray: [UIImage] = []
    private var appUrlArray: [String] = []
    // Hopefully one day we do not have to do this, but currently I cannot get [UIImage] to be passed over UserDefaults
    //let appImageDictionary:[String:UIImage] = ["BBC":UIImage(named: "bbc")!, "Facebook":UIImage(named: "facebook")!, "Instagram":UIImage(named: "instagram")!, "Quora":UIImage(named: "quora")!, "Reddit":UIImage(named: "reddit")!, "Whatsapp":UIImage(named: "whatsapp")!, "Youtube":UIImage(named: "youtube")!, "9GAG":UIImage(named: "9gag")!, "Clash Of Clans":UIImage(named: "clashofclans")!, "Google+":UIImage(named: "google+")!, "Messenger":UIImage(named: "messenger")!, "Netflix":UIImage(named: "netflix")!, "Pinterest":UIImage(named: "pinterest")!, "Snapchat":UIImage(named: "snapchat")!, "Twitter":UIImage(named: "twitter")!, "WeChat":UIImage(named: "wechat")!]
    let defaults = UserDefaults.init(suiteName: "group.nauynix.rails")

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var bottomAppStackView: UIStackView!
    @IBOutlet weak var bottomLabelStackView: UIStackView!
    static private var progressView:UIProgressView!
    static private var resetButton:UIButton!
    static private var timeLeftLabel:UILabel!
    
    
    
    func buttonDown(){
        var timeIndex = 0
        var index = 0
        TodayViewController.timeSetInMinutes = 2
        TodayViewController.timeLeftLabel.text = "\(TodayViewController.timeSetInMinutes) minutes"
        TodayViewController.timerForSettingTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { (Timer) in
            // Animate the progress bar and get the final time set
            if index < 30 { // User needs to hold for one second
                //self.progressView.setProgress(0.0016 * Float(index) + Float(timeIndex) * 0.25, animated: true)
                TodayViewController.progressView.setProgress(0.0345 * Float(index), animated: false)
                index+=1
            }
            else if timeIndex < 4{ // Change to the next timer countdown
                timeIndex += 1
                index = 0
                TodayViewController.timeSetInMinutes = self.timeInteverals[timeIndex]
                TodayViewController.timeLeftLabel.text = "\(TodayViewController.timeSetInMinutes) minutes"
                //self.progressView.setProgress(Float(timeIndex) * 0.25, animated: true)
                TodayViewController.progressView.setProgress(0, animated: false)
            }
            else{ // Maximum timer reached, do nothing
                TodayViewController.timeSetInMinutes = self.timeInteverals[timeIndex]
                TodayViewController.timeLeftLabel.text = "\(TodayViewController.timeSetInMinutes) minutes"
                //self.progressView.setProgress(Float(timeIndex) * 0.25, animated: true)
                TodayViewController.progressView.setProgress(1, animated: false)
            }
        })
        /*
        TodayViewController.timerForSettingTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { (Timer) in
            // Start animating the fading to black of the button and getting the final time set
            if index < 30 && timeIndex <= 3{
                var red:CGFloat = 0
                var green:CGFloat = 0
                var blue:CGFloat = 0
                var alpha:CGFloat = 0
                self.bottomLabel.backgroundColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                red=max(0,red-0.03)
                blue=max(0,blue-0.03)
                green=max(0,green-0.03)
                self.bottomLabel.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                index+=1
            }
            else{
            // Continue staying at the same colour once the max time is reached
                self.button8.backgroundColor = UIColor(red: self.defaultRed, green: self.defaultGreen, blue: self.defaultBlue, alpha: self.defaultAlpha)
                timeIndex = min(4, timeIndex + 1)
                TodayViewController.timeSetInMinutes = self.timeInteverals[timeIndex]
                self.bottomLabel.text = "\(TodayViewController.timeSetInMinutes) minutes"
            }
        })*/
    }
    
    func buttonUp(){
        // Invalidate the animation timer, keep track of the date started, and start the counting down timer
        self.disableAllButtons()
        
        TodayViewController.progressView.setProgress(1, animated: false)
        
        TodayViewController.timerForSettingTimer?.invalidate()
        
        TodayViewController.timerForSettingTimer = nil
        
        if defaults?.object(forKey: "timerStartedDate") != nil{ // Has already been initialised (either by widget or from notification)
            TodayViewController.timerStartedDate = defaults?.object(forKey: "timerStartedDate") as! Date
        }
        else{
            TodayViewController.timerStartedDate = Date()
        }
        
        TodayViewController.timerHasStarted = true
        
        button1.isSelected = true
        button2.isSelected = true
        button3.isSelected = true
        button4.isSelected = true
        button5.isSelected = true
        button6.isSelected = true
        button7.isSelected = true
        button8.isSelected = true
        if appNameArray[TodayViewController.buttonSelected - 1] != "Others"{
            self.extensionContext?.open(URL(string: appUrlArray[TodayViewController.buttonSelected - 1])!)
        }
        
        defaults?.set(true, forKey: "notificationIsNotSent")
        defaults?.set(TodayViewController.timeSetInMinutes, forKey: "timeSetInMinutes")
        defaults?.set(TodayViewController.timerStartedDate, forKey: "timerStartedDate")
        
        // Set totalTimeLoggedPerDay for notificationHandler in main app
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        var totalTimeLoggedPerDay = (defaults?.object(forKey: "totalTimeLoggedPerDay") as? [String:Int])!
        
        if totalTimeLoggedPerDay[dateFormatter.string(from: Date())] != nil{
            totalTimeLoggedPerDay[dateFormatter.string(from: Date())]! += (defaults?.integer(forKey: "timeSetInMinutes"))! * 60
        }
        else{
            totalTimeLoggedPerDay[dateFormatter.string(from: Date())] = (defaults?.integer(forKey: "timeSetInMinutes"))! * 60
            print(totalTimeLoggedPerDay[dateFormatter.string(from: Date())]!)
        }
        defaults?.set(totalTimeLoggedPerDay, forKey: "totalTimeLoggedPerDay")
        
        timeCountDown()
    }
    
    func timeCountDown(){
        // While the widget is active, the timer will be counting down via a timer.
        updateCounter()
        if TodayViewController.timeSetInMinutes != 0{
            if TodayViewController.timerForCountingDown == nil {
                TodayViewController.timerForCountingDown =  Timer.scheduledTimer(
                    timeInterval: TimeInterval(1),
                    target      : self,
                    selector    : #selector(TodayViewController.updateCounter),
                    userInfo    : nil,
                    repeats     : true)
            }
            else{ // By right this should never happen as the timerForCountingDown will be set to nil
                print("Why is this happening whatever nobody needs to know about this.")
            }
        }
    }
    
    func updateCounter(){
        // Update counter
        // Get time difference
        let timeLeftInSeconds:Int
        if self.defaults?.integer(forKey: "timeSetInMinutes") == 0{ // The phone has been locked triggering the locked function in notificationhandler of rails app to set timeSetInMinutes to 0
            timeLeftInSeconds = 0
            TodayViewController.timeSetInMinutes = 0
        }
        else{ // The timer is still running.
            if defaults?.object(forKey: "timerStartedDate") != nil{ // Has already been initialised (either by widget or from notification)
                TodayViewController.timerStartedDate = defaults?.object(forKey: "timerStartedDate") as! Date
            }
            else{
                TodayViewController.timerStartedDate = Date()
            }
            timeLeftInSeconds = TodayViewController.timeSetInMinutes * 60 + Int(round(TodayViewController.timerStartedDate.timeIntervalSinceNow))
        }
        if timeLeftInSeconds > 0{
            let minutes:Int = timeLeftInSeconds / 60
            let seconds = String(timeLeftInSeconds % 60)
            let paddedSeconds = seconds.leftPadding(toLength: 2, withPad: "0")
            TodayViewController.timeLeftLabel.text = "\(minutes):\(paddedSeconds)"
            TodayViewController.progressView.setProgress(Float(timeLeftInSeconds) / Float(TodayViewController.timeSetInMinutes * 60), animated: false)
        }
        else{ // Reset timer
            resetTimer()
        }
        print("whatsup")
    }
    
    func resetTimer(){
        self.defaults?.removeObject(forKey: "url")
        self.defaults?.removeObject(forKey: "timeSetInMinutes")
        self.defaults?.removeObject(forKey: "timerStartedDate")
        TodayViewController.timeSetInMinutes = 0
        TodayViewController.timerForSettingTimer?.invalidate()
        TodayViewController.timerForSettingTimer = nil
        TodayViewController.timerForCountingDown?.invalidate()
        TodayViewController.timerForCountingDown = nil
        TodayViewController.timerHasStarted = false
        UIView.animate(withDuration: 0.4, animations: {
            TodayViewController.progressView.frame.origin.x = TodayViewController.progressViewInitialX
        })
        UIView.animate(withDuration: 0.4, delay: 0.1, animations: {
            TodayViewController.resetButton.frame.origin.x = TodayViewController.resetButtonInitialX
        })
        UIView.animate(withDuration: 0.4, delay: 0.2, animations: {
            TodayViewController.timeLeftLabel.frame.origin.x = TodayViewController.timeLeftLabelInitialX
            self.setButtons()
            self.showButtons()
        }, completion: { (true) in
            TodayViewController.timeLeftLabel.removeFromSuperview()
            TodayViewController.resetButton.removeFromSuperview()
            TodayViewController.progressView.removeFromSuperview()
            self.enableAllButtons()
        })
    }
    
    func setButtons(){
        // Setting label text to app name
        // Setting imageview to app icons
        // First button will always be present as there has to be an 'other' icon
        // There has to be a better way to do this...
        label1.text = appNameArray[0]
        button1.setImage(appImageArray[0], for: .normal)
        if 1 < appNameArray.count{
            label2.text = appNameArray[1]
            button2.setImage(appImageArray[1], for: .normal)
        }
        if 2 < appNameArray.count{
            label3.text = appNameArray[2]
            button3.setImage(appImageArray[2], for: .normal)
        }
        if 3 < appNameArray.count{
            label4.text = appNameArray[3]
            button4.setImage(appImageArray[3], for: .normal)
        }
        if 4 < appNameArray.count{
            label5.text = appNameArray[4]
            button5.setImage(appImageArray[4], for: .normal)
        }
        if 5 < appNameArray.count{
            label6.text = appNameArray[5]
            button6.setImage(appImageArray[5], for: .normal)
        }
        if 6 < appNameArray.count{
            label7.text = appNameArray[6]
            button7.setImage(appImageArray[6], for: .normal)
        }
        if 7 < appNameArray.count{
            label8.text = appNameArray[7]
            button8.setImage(appImageArray[7], for: .normal)
        }
    }
    
    func showButtons(){
        // Setting alpha of imageviews and labels
        // First button will always be present as there has to be an 'other' icon
        // There has to be a better way to do this...
        self.button1.alpha = 1
        self.label1.alpha = 1
        if 1 < appNameArray.count{
            self.button2.alpha = 1
            self.label2.alpha = 1
        }
        if 2 < appNameArray.count{
            self.button3.alpha = 1
            self.label3.alpha = 1
        }
        if 3 < appNameArray.count{
            self.button4.alpha = 1
            self.label4.alpha = 1
        }
        if 4 < appNameArray.count{
            self.button5.alpha = 1
            self.label5.alpha = 1
        }
        if 5 < appNameArray.count{
            self.button6.alpha = 1
            self.label6.alpha = 1
        }
        if 6 < appNameArray.count{
            self.button7.alpha = 1
            self.label7.alpha = 1
        }
        if 7 < appNameArray.count{
            self.button8.alpha = 1
            self.label8.alpha = 1
        }
    }
    
    func enableAllButtons(){
        self.button1.isUserInteractionEnabled = true
        self.button2.isUserInteractionEnabled = true
        self.button3.isUserInteractionEnabled = true
        self.button4.isUserInteractionEnabled = true
        self.button5.isUserInteractionEnabled = true
        self.button6.isUserInteractionEnabled = true
        self.button7.isUserInteractionEnabled = true
        self.button8.isUserInteractionEnabled = true

    }
    
    func disableAllButtons(){
        button1.isUserInteractionEnabled = false
        button2.isUserInteractionEnabled = false
        button3.isUserInteractionEnabled = false
        button4.isUserInteractionEnabled = false
        button5.isUserInteractionEnabled = false
        button6.isUserInteractionEnabled = false
        button7.isUserInteractionEnabled = false
        button8.isUserInteractionEnabled = false
    }
    
    func createResetButton(x:Int, y:Int, width:Int, height:Int){
        TodayViewController.resetButton = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
        TodayViewController.resetButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        TodayViewController.resetButton.backgroundColor = UIColor.lightText
        TodayViewController.resetButton.setTitleColor(.black, for: .normal)
        TodayViewController.resetButton.setTitle("Reset", for: .normal)
        TodayViewController.resetButton.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        TodayViewController.resetButton.layer.cornerRadius = 13
        TodayViewController.resetButton.clipsToBounds = true
        TodayViewController.resetButtonInitialX = CGFloat(x)
        TodayViewController.resetButton.alpha = 1
    }
    
    func createLabel(x:Int, y:Int, width:Int, height:Int){
        TodayViewController.timeLeftLabel = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        TodayViewController.timeLeftLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        TodayViewController.timeLeftLabel.textColor = .black
        TodayViewController.timeLeftLabel.backgroundColor = UIColor.lightText
        TodayViewController.timeLeftLabel.layer.cornerRadius = 13
        TodayViewController.timeLeftLabel.clipsToBounds = true
        TodayViewController.timeLeftLabel.textAlignment = .center
        TodayViewController.timeLeftLabel.text = "\(TodayViewController.timeSetInMinutes) Minutes"
        TodayViewController.timeLeftLabelInitialX = CGFloat(x)
        TodayViewController.timeLeftLabel.alpha = 1
    }
    
    func createProgressView(x:Int, y:Int, width:Int, height:Int){
        TodayViewController.progressView = UIProgressView(frame: CGRect(x: x, y: y, width: width, height: height))
        TodayViewController.progressView.backgroundColor = UIColor.lightText
        TodayViewController.progressView.layer.cornerRadius = 13
        TodayViewController.progressView.clipsToBounds = true
        TodayViewController.progressViewInitialX = CGFloat(x)
        TodayViewController.progressView.alpha = 1
    }
    //MARK: Actions
    
    @IBAction func touchUpInside(_ sender: UIButton) { // Called by reset timer button
        resetTimer()
    }

    //MARK: Start
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TodayViewController.timerForSettingTimer?.invalidate()
        TodayViewController.timerForSettingTimer = nil
        
        // Update image, url and name
        appNameArray = defaults?.array(forKey: "selectedAppsString") as! [String]
        appUrlArray = defaults?.array(forKey: "selectedAppsURL") as! [String]
        appImageArray = []
        let numberOfImages = (defaults?.integer(forKey: "numberOfImages"))!
        for i in 0..<numberOfImages{
            if let imgData = defaults?.object(forKey: "image\(i)") as? NSData
            {
                if let image = UIImage(data: imgData as Data)
                {
                    appImageArray.append(image)
                }
            }
        }
        
        // Setting corner radius
        button1.layer.cornerRadius = 13
        button2.layer.cornerRadius = 13
        button3.layer.cornerRadius = 13
        button4.layer.cornerRadius = 13
        button5.layer.cornerRadius = 13
        button6.layer.cornerRadius = 13
        button7.layer.cornerRadius = 13
        button8.layer.cornerRadius = 13
        setButtons()
        /*
        label2.text = appNameArray[1]
        label3.text = appNameArray[2]
        label4.text = appNameArray[3]
        label5.text = appNameArray[4]
        label6.text = appNameArray[5]
        label7.text = appNameArray[6]
        label8.text = appNameArray[7]button1.setImage(appImageArray[0], for: .normal)
        button2.setImage(appImageArray[1], for: .normal)
        button3.setImage(appImageArray[2], for: .normal)
        button4.setImage(appImageArray[3], for: .normal)
        button5.setImage(appImageArray[4], for: .normal)
        button6.setImage(appImageArray[5], for: .normal)
        button7.setImage(appImageArray[6], for: .normal)
        button8.setImage(appImageArray[7], for: .normal)*/
        
        // Initialise key if not zero I think
        TodayViewController.timeSetInMinutes = defaults?.integer(forKey: "timeSetInMinutes") ?? 0
        
        // No idea what this does lmao but no reason to remove it - 30/04/17
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        
        // Setting gestures
        var longPress = UILongPressGestureRecognizer(target: self, action: #selector(TodayViewController.longTapButton1(_:)))
        longPress.minimumPressDuration = 0.6
        longPress.allowableMovement = 120
        button1.addGestureRecognizer(longPress)
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(TodayViewController.longTapButton2(_:)))
        longPress.minimumPressDuration = 0.6
        longPress.allowableMovement = 120
        button2.addGestureRecognizer(longPress)
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(TodayViewController.longTapButton3(_:)))
        longPress.minimumPressDuration = 0.6
        longPress.allowableMovement = 120
        button3.addGestureRecognizer(longPress)
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(TodayViewController.longTapButton4(_:)))
        longPress.minimumPressDuration = 0.6
        longPress.allowableMovement = 120
        button4.addGestureRecognizer(longPress)
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(TodayViewController.longTapButton5(_:)))
        longPress.minimumPressDuration = 0.6
        longPress.allowableMovement = 120
        button5.addGestureRecognizer(longPress)
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(TodayViewController.longTapButton6(_:)))
        longPress.minimumPressDuration = 0.6
        longPress.allowableMovement = 120
        button6.addGestureRecognizer(longPress)
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(TodayViewController.longTapButton7(_:)))
        longPress.minimumPressDuration = 0.6
        longPress.allowableMovement = 120
        button7.addGestureRecognizer(longPress)
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(TodayViewController.longTapButton8(_:)))
        longPress.minimumPressDuration = 0.6
        longPress.allowableMovement = 120
        button8.addGestureRecognizer(longPress)
        
        print("view loaded")
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize){
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = CGSize(width: 0, height: 110)
            bottomAppStackView.alpha = 0
            bottomLabelStackView.isHidden = true
        }
        else {
            self.preferredContentSize = CGSize(width: 0, height: 175)
            bottomAppStackView.alpha = 1
            bottomLabelStackView.isHidden = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        TodayViewController.timerForCountingDown?.invalidate()
        TodayViewController.timerForCountingDown = nil
        if (TodayViewController.timeLeftLabel != nil){
            TodayViewController.timeLeftLabel.removeFromSuperview()
        }
        if (TodayViewController.resetButton != nil){
            TodayViewController.resetButton.removeFromSuperview()
        }
        if (TodayViewController.progressView != nil){
            TodayViewController.progressView.removeFromSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stackSpacing = button4.layer.frame.origin.x - button3.layer.frame.origin.x - appSize
        if TodayViewController.timeSetInMinutes != 0{
            self.button1.alpha = 0
            self.button2.alpha = 0
            self.button3.alpha = 0
            self.button4.alpha = 0
            self.button5.alpha = 0
            self.button6.alpha = 0
            self.button7.alpha = 0
            self.button8.alpha = 0
            self.label1.alpha = 0
            self.label2.alpha = 0
            self.label3.alpha = 0
            self.label4.alpha = 0
            self.label5.alpha = 0
            self.label6.alpha = 0
            self.label7.alpha = 0
            self.label8.alpha = 0
            disableAllButtons()
            if TodayViewController.timeSetInMinutes != 0 && TodayViewController.timerHasStarted == false { // User started a timer from notification. Select the others app
                TodayViewController.buttonSelected = appNameArray.count
                defaults?.set(true, forKey: "notificationIsNotSent")
            }
            switch TodayViewController.buttonSelected {
            case 1:
                self.button1.alpha = 1
                self.label1.alpha = 1
                createLabel(x: Int(button2.frame.origin.x + view.bounds.width), y: Int(button1.frame.origin.y), width: Int(2 * appSize + stackSpacing), height: Int(appSize))
                createResetButton(x: Int(button4.frame.origin.x + view.bounds.width), y: Int(button1.frame.origin.y), width: Int(appSize), height: Int(appSize))
                createProgressView(x: Int(button5.frame.origin.x + view.bounds.width), y: Int(button1.frame.origin.y + appSize / 2), width: Int(appSize * 4 + stackSpacing * 3), height: Int(appSize))
                TodayViewController.timeLeftLabel.frame.origin.x -= self.view.bounds.width
                TodayViewController.resetButton.frame.origin.x -= self.view.bounds.width
                TodayViewController.progressView.frame.origin.x -= self.view.bounds.width
                button1.superview?.addSubview(TodayViewController.timeLeftLabel)
                button1.superview?.addSubview(TodayViewController.resetButton)
                button5.superview?.addSubview(TodayViewController.progressView)
            case 2:
                self.button2.alpha = 1
                self.label2.alpha = 1
                createLabel(x: Int(button3.frame.origin.x + view.bounds.width), y: Int(button1.frame.origin.y), width: Int(2 * appSize + stackSpacing), height: Int(appSize))
                createResetButton(x: Int(button1.frame.origin.x - view.bounds.width), y: Int(button1.frame.origin.y), width: Int(appSize), height: Int(appSize))
                createProgressView(x: Int(button5.frame.origin.x + view.bounds.width), y: Int(button1.frame.origin.y + appSize / 2), width: Int(appSize * 4 + stackSpacing * 3), height: Int(appSize))
                TodayViewController.timeLeftLabel.frame.origin.x -= self.view.bounds.width
                TodayViewController.resetButton.frame.origin.x += self.view.bounds.width
                TodayViewController.progressView.frame.origin.x -= self.view.bounds.width
                button1.superview?.addSubview(TodayViewController.timeLeftLabel)
                button1.superview?.addSubview(TodayViewController.resetButton)
                button5.superview?.addSubview(TodayViewController.progressView)
            case 3:
                self.button3.alpha = 1
                self.label3.alpha = 1
                createLabel(x: Int(button1.frame.origin.x - view.bounds.width), y: Int(button1.frame.origin.y), width: Int(2 * appSize + stackSpacing), height: Int(appSize))
                createResetButton(x: Int(button4.frame.origin.x + view.bounds.width), y: Int(button1.frame.origin.y), width: Int(appSize), height: Int(appSize))
                createProgressView(x: Int(button5.frame.origin.x - view.bounds.width), y: Int(button1.frame.origin.y + appSize / 2), width: Int(appSize * 4 + stackSpacing * 3), height: Int(appSize))
                TodayViewController.timeLeftLabel.frame.origin.x += self.view.bounds.width
                TodayViewController.resetButton.frame.origin.x -= self.view.bounds.width
                TodayViewController.progressView.frame.origin.x += self.view.bounds.width
                button1.superview?.addSubview(TodayViewController.timeLeftLabel)
                button1.superview?.addSubview(TodayViewController.resetButton)
                button5.superview?.addSubview(TodayViewController.progressView)
            case 4:
                self.button4.alpha = 1
                self.label4.alpha = 1
                createLabel(x: Int(button2.frame.origin.x - view.bounds.width), y: Int(button1.frame.origin.y), width: Int(2 * appSize + stackSpacing), height: Int(appSize))
                createResetButton(x: Int(button1.frame.origin.x - view.bounds.width), y: Int(button1.frame.origin.y), width: Int(appSize), height: Int(appSize))
                createProgressView(x: Int(button5.frame.origin.x - view.bounds.width), y: Int(button1.frame.origin.y + appSize / 2), width: Int(appSize * 4 + stackSpacing * 3), height: Int(appSize))
                TodayViewController.timeLeftLabel.frame.origin.x += self.view.bounds.width
                TodayViewController.resetButton.frame.origin.x += self.view.bounds.width
                TodayViewController.progressView.frame.origin.x += self.view.bounds.width
                button1.superview?.addSubview(TodayViewController.timeLeftLabel)
                button1.superview?.addSubview(TodayViewController.resetButton)
                button5.superview?.addSubview(TodayViewController.progressView)
            case 5:
                self.button5.alpha = 1
                self.label5.alpha = 1
                createLabel(x: Int(button2.frame.origin.x + view.bounds.width), y: Int(button1.frame.origin.y), width: Int(2 * appSize + stackSpacing), height: Int(appSize))
                createResetButton(x: Int(button4.frame.origin.x + view.bounds.width), y: Int(button1.frame.origin.y), width: Int(appSize), height: Int(appSize))
                createProgressView(x: Int(button5.frame.origin.x + view.bounds.width), y: Int(button1.frame.origin.y + appSize / 2), width: Int(appSize * 4 + stackSpacing * 3), height: Int(appSize))
                TodayViewController.timeLeftLabel.frame.origin.x -= self.view.bounds.width
                TodayViewController.resetButton.frame.origin.x -= self.view.bounds.width
                TodayViewController.progressView.frame.origin.x -= self.view.bounds.width
                button5.superview?.addSubview(TodayViewController.timeLeftLabel)
                button5.superview?.addSubview(TodayViewController.resetButton)
                button1.superview?.addSubview(TodayViewController.progressView)
            case 6:
                self.button6.alpha = 1
                self.label6.alpha = 1
                createLabel(x: Int(button3.frame.origin.x + view.bounds.width), y: Int(button1.frame.origin.y), width: Int(2 * appSize + stackSpacing), height: Int(appSize))
                createResetButton(x: Int(button1.frame.origin.x - view.bounds.width), y: Int(button1.frame.origin.y), width: Int(appSize), height: Int(appSize))
                createProgressView(x: Int(button5.frame.origin.x + view.bounds.width), y: Int(button1.frame.origin.y + appSize / 2), width: Int(appSize * 4 + stackSpacing * 3), height: Int(appSize))
                TodayViewController.timeLeftLabel.frame.origin.x -= self.view.bounds.width
                TodayViewController.resetButton.frame.origin.x += self.view.bounds.width
                TodayViewController.progressView.frame.origin.x -= self.view.bounds.width
                button5.superview?.addSubview(TodayViewController.timeLeftLabel)
                button5.superview?.addSubview(TodayViewController.resetButton)
                button1.superview?.addSubview(TodayViewController.progressView)
            case 7:
                self.button7.alpha = 1
                self.label7.alpha = 1
                createLabel(x: Int(button1.frame.origin.x - view.bounds.width), y: Int(button1.frame.origin.y), width: Int(2 * appSize + stackSpacing), height: Int(appSize))
                createResetButton(x: Int(button4.frame.origin.x + view.bounds.width), y: Int(button1.frame.origin.y), width: Int(appSize), height: Int(appSize))
                createProgressView(x: Int(button5.frame.origin.x - view.bounds.width), y: Int(button1.frame.origin.y + appSize / 2), width: Int(appSize * 4 + stackSpacing * 3), height: Int(appSize))
                TodayViewController.timeLeftLabel.frame.origin.x += self.view.bounds.width
                TodayViewController.resetButton.frame.origin.x -= self.view.bounds.width
                TodayViewController.progressView.frame.origin.x += self.view.bounds.width
                button5.superview?.addSubview(TodayViewController.timeLeftLabel)
                button5.superview?.addSubview(TodayViewController.resetButton)
                button1.superview?.addSubview(TodayViewController.progressView)
            case 8:
                self.button8.alpha = 1
                self.label8.alpha = 1
                createLabel(x: Int(button2.frame.origin.x - view.bounds.width), y: Int(button1.frame.origin.y), width: Int(2 * appSize + stackSpacing), height: Int(appSize))
                createResetButton(x: Int(button1.frame.origin.x - view.bounds.width), y: Int(button1.frame.origin.y), width: Int(appSize), height: Int(appSize))
                createProgressView(x: Int(button5.frame.origin.x - view.bounds.width), y: Int(button1.frame.origin.y + appSize / 2), width: Int(appSize * 4 + stackSpacing * 3), height: Int(appSize))
                TodayViewController.timeLeftLabel.frame.origin.x += self.view.bounds.width
                TodayViewController.resetButton.frame.origin.x += self.view.bounds.width
                TodayViewController.progressView.frame.origin.x += self.view.bounds.width
                button5.superview?.addSubview(TodayViewController.timeLeftLabel)
                button5.superview?.addSubview(TodayViewController.resetButton)
                button1.superview?.addSubview(TodayViewController.progressView)
            default:
                break
            }
            if TodayViewController.timeSetInMinutes != 0 && TodayViewController.timerHasStarted == false { // User started a timer from notification
                buttonUp()
            }
            self.timeCountDown()
        }
        else{
            showButtons()
        }
    }
    
    func animateBegin(labelX: Int, labelButton: UIButton, resetX: Int, resetButton: UIButton, progressX: Int, progressButton: UIButton, finalLabelX: CGFloat, finalResetX: CGFloat, finalProgressX: CGFloat, selectedButton: UIButton, selectedLabel: UILabel){
        buttonState = 1
        minimumAllowedMovements = 5
        // Because stack.spacing does not work and must be called after viewDidLoad
        stackSpacing = button4.layer.frame.origin.x - button3.layer.frame.origin.x - appSize
        createLabel(x: labelX, y: Int(button1.frame.origin.y), width: Int(2 * appSize + stackSpacing), height: Int(appSize))
        createResetButton(x: resetX, y: Int(button1.frame.origin.y), width: Int(appSize), height: Int(appSize))
        createProgressView(x: progressX, y: Int(button1.frame.origin.y + appSize / 2), width: Int(appSize * 4 + stackSpacing * 3), height: Int(appSize))
        self.buttonDown()
        labelButton.superview?.addSubview(TodayViewController.timeLeftLabel)
        resetButton.superview?.addSubview(TodayViewController.resetButton)
        progressButton.superview?.addSubview(TodayViewController.progressView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.2, animations: {
            self.button1.alpha = 0
            self.button2.alpha = 0
            self.button3.alpha = 0
            self.button4.alpha = 0
            self.button5.alpha = 0
            self.button6.alpha = 0
            self.button7.alpha = 0
            self.button8.alpha = 0
            self.label1.alpha = 0
            self.label2.alpha = 0
            self.label3.alpha = 0
            self.label4.alpha = 0
            self.label5.alpha = 0
            self.label6.alpha = 0
            self.label7.alpha = 0
            self.label8.alpha = 0
            selectedButton.alpha = 1
            selectedLabel.alpha = 1
            TodayViewController.timeLeftLabel.frame.origin.x = finalLabelX
        })
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.2, animations: {
            TodayViewController.resetButton.frame.origin.x = finalResetX
        })
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.2, animations: {
            TodayViewController.progressView.frame.origin.x = finalProgressX
        })
    }
    
    func longTapButton1(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began && buttonState != 1{ //If the user double taps, nothing happens
            print("UIGestureRecognizerStateBegan")
            TodayViewController.buttonSelected = 1
            animateBegin(labelX: Int(button2.frame.origin.x + view.bounds.width), labelButton: button1, resetX: Int(button4.frame.origin.x + view.bounds.width), resetButton: button1, progressX: Int(button5.frame.origin.x + view.bounds.width), progressButton: button5, finalLabelX: button2.frame.origin.x, finalResetX: button4.frame.origin.x, finalProgressX: button5.frame.origin.x, selectedButton: button1, selectedLabel: label1)
        }
        else if gesture.state == .ended && buttonState != 3{ // User lifts finger and the action has not been cancelled yet
            print("UIGestureRecognizerStateEnded.")
            buttonUp()
            buttonState = 2
        }
        else{ // Any slight movement in the finger holding it down will trigger this and it is very sensitive. As such, we put a buffer of 5 to ensure that this only triggers when the user swipes out of the button
            minimumAllowedMovements -= 1
            if minimumAllowedMovements == 0 && buttonState != 3{
                print("cancel")
                buttonState = 3
                TodayViewController.timeLeftLabel.text = "Cancelled"
                resetTimer()
            }
        }
    }
    
    func longTapButton2(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began && buttonState != 1{ //If the user double taps, nothing happens
            print("UIGestureRecognizerStateBegan")
            TodayViewController.buttonSelected = 2
            animateBegin(labelX: Int(button3.frame.origin.x + view.bounds.width), labelButton: button1, resetX: Int(button1.frame.origin.x - view.bounds.width), resetButton: button1, progressX: Int(button5.frame.origin.x + view.bounds.width), progressButton: button5, finalLabelX: button3.frame.origin.x, finalResetX: button1.frame.origin.x, finalProgressX: button5.frame.origin.x, selectedButton: button2, selectedLabel: label2)
        }
        else if gesture.state == .ended && buttonState != 3{ // User lifts finger and the action has not been cancelled yet
            print("UIGestureRecognizerStateEnded.")
            buttonUp()
            buttonState = 2
        }
        else{ // Any slight movement in the finger holding it down will trigger this and it is very sensitive. As such, we put a buffer of 5 to ensure that this only triggers when the user swipes out of the button
            minimumAllowedMovements -= 1
            if minimumAllowedMovements == 0 && buttonState != 3{
                print("cancel")
                buttonState = 3
                TodayViewController.timeLeftLabel.text = "Cancelled"
                resetTimer()
            }
        }
    }
    
    func longTapButton3(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began && buttonState != 1{ //If the user double taps, nothing happens
            print("UIGestureRecognizerStateBegan")
            TodayViewController.buttonSelected = 3
            animateBegin(labelX: Int(button1.frame.origin.x - view.bounds.width), labelButton: button1, resetX: Int(button4.frame.origin.x + view.bounds.width), resetButton: button1, progressX: Int(button5.frame.origin.x - view.bounds.width), progressButton: button5, finalLabelX: button1.frame.origin.x, finalResetX: button4.frame.origin.x, finalProgressX: button5.frame.origin.x, selectedButton: button3, selectedLabel: label3)
        }
        else if gesture.state == .ended && buttonState != 3{ // User lifts finger and the action has not been cancelled yet
            print("UIGestureRecognizerStateEnded.")
            buttonUp()
            buttonState = 2
        }
        else{ // Any slight movement in the finger holding it down will trigger this and it is very sensitive. As such, we put a buffer of 5 to ensure that this only triggers when the user swipes out of the button
            minimumAllowedMovements -= 1
            if minimumAllowedMovements == 0 && buttonState != 3{
                print("cancel")
                buttonState = 3
                TodayViewController.timeLeftLabel.text = "Cancelled"
                resetTimer()
            }
        }
    }
    
    func longTapButton4(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began && buttonState != 1{ //If the user double taps, nothing happens
            print("UIGestureRecognizerStateBegan")
            TodayViewController.buttonSelected = 4
            animateBegin(labelX: Int(button2.frame.origin.x - view.bounds.width), labelButton: button1, resetX: Int(button1.frame.origin.x - view.bounds.width), resetButton: button1, progressX: Int(button5.frame.origin.x - view.bounds.width), progressButton: button5, finalLabelX: button2.frame.origin.x, finalResetX: button1.frame.origin.x, finalProgressX: button5.frame.origin.x, selectedButton: button4, selectedLabel: label4)
        }
        else if gesture.state == .ended && buttonState != 3{ // User lifts finger and the action has not been cancelled yet
            print("UIGestureRecognizerStateEnded.")
            buttonUp()
            buttonState = 2
        }
        else{ // Any slight movement in the finger holding it down will trigger this and it is very sensitive. As such, we put a buffer of 5 to ensure that this only triggers when the user swipes out of the button
            minimumAllowedMovements -= 1
            if minimumAllowedMovements == 0 && buttonState != 3{
                print("cancel")
                buttonState = 3
                TodayViewController.timeLeftLabel.text = "Cancelled"
                resetTimer()
            }
        }
    }
    
    func longTapButton5(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began && buttonState != 1{ //If the user double taps, nothing happens
            print("UIGestureRecognizerStateBegan")
            TodayViewController.buttonSelected = 5
            animateBegin(labelX: Int(button2.frame.origin.x + view.bounds.width), labelButton: button5, resetX: Int(button4.frame.origin.x + view.bounds.width), resetButton: button5, progressX: Int(button5.frame.origin.x + view.bounds.width), progressButton: button1, finalLabelX: button2.frame.origin.x, finalResetX: button4.frame.origin.x, finalProgressX: button5.frame.origin.x, selectedButton: button5, selectedLabel: label5)
        }
        else if gesture.state == .ended && buttonState != 3{ // User lifts finger and the action has not been cancelled yet
            print("UIGestureRecognizerStateEnded.")
            buttonUp()
            buttonState = 2
        }
        else{ // Any slight movement in the finger holding it down will trigger this and it is very sensitive. As such, we put a buffer of 5 to ensure that this only triggers when the user swipes out of the button
            minimumAllowedMovements -= 1
            if minimumAllowedMovements == 0 && buttonState != 3{
                print("cancel")
                buttonState = 3
                TodayViewController.timeLeftLabel.text = "Cancelled"
                resetTimer()
            }
        }
    }
    
    func longTapButton6(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began && buttonState != 1{ //If the user double taps, nothing happens
            print("UIGestureRecognizerStateBegan")
            TodayViewController.buttonSelected = 6
            animateBegin(labelX: Int(button3.frame.origin.x + view.bounds.width), labelButton: button5, resetX: Int(button1.frame.origin.x - view.bounds.width), resetButton: button5, progressX: Int(button5.frame.origin.x + view.bounds.width), progressButton: button1, finalLabelX: button3.frame.origin.x, finalResetX: button1.frame.origin.x, finalProgressX: button5.frame.origin.x, selectedButton: button6, selectedLabel: label6)
        }
        else if gesture.state == .ended && buttonState != 3{ // User lifts finger and the action has not been cancelled yet
            print("UIGestureRecognizerStateEnded.")
            buttonUp()
            buttonState = 2
        }
        else{ // Any slight movement in the finger holding it down will trigger this and it is very sensitive. As such, we put a buffer of 5 to ensure that this only triggers when the user swipes out of the button
            minimumAllowedMovements -= 1
            if minimumAllowedMovements == 0 && buttonState != 3{
                print("cancel")
                buttonState = 3
                TodayViewController.timeLeftLabel.text = "Cancelled"
                resetTimer()
            }
        }
    }
    
    func longTapButton7(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began && buttonState != 1{ //If the user double taps, nothing happens
            print("UIGestureRecognizerStateBegan")
            TodayViewController.buttonSelected = 7
            animateBegin(labelX: Int(button1.frame.origin.x - view.bounds.width), labelButton: button5, resetX: Int(button4.frame.origin.x + view.bounds.width), resetButton: button5, progressX: Int(button5.frame.origin.x - view.bounds.width), progressButton: button1, finalLabelX: button1.frame.origin.x, finalResetX: button4.frame.origin.x, finalProgressX: button5.frame.origin.x, selectedButton: button7, selectedLabel: label7)
        }
        else if gesture.state == .ended && buttonState != 3{ // User lifts finger and the action has not been cancelled yet
            print("UIGestureRecognizerStateEnded.")
            buttonUp()
            buttonState = 2
        }
        else{ // Any slight movement in the finger holding it down will trigger this and it is very sensitive. As such, we put a buffer of 5 to ensure that this only triggers when the user swipes out of the button
            minimumAllowedMovements -= 1
            if minimumAllowedMovements == 0 && buttonState != 3{
                print("cancel")
                buttonState = 3
                TodayViewController.timeLeftLabel.text = "Cancelled"
                resetTimer()
            }
        }
    }
    
    func longTapButton8(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began && buttonState != 1{ //If the user double taps, nothing happens
            print("UIGestureRecognizerStateBegan")
            TodayViewController.buttonSelected = 8
            animateBegin(labelX: Int(button2.frame.origin.x - view.bounds.width), labelButton: button5, resetX: Int(button1.frame.origin.x - view.bounds.width), resetButton: button5, progressX: Int(button5.frame.origin.x - view.bounds.width), progressButton: button1, finalLabelX: button2.frame.origin.x, finalResetX: button1.frame.origin.x, finalProgressX: button5.frame.origin.x, selectedButton: button8, selectedLabel: label8)
        }
        else if gesture.state == .ended && buttonState != 3{ // User lifts finger and the action has not been cancelled yet
            print("UIGestureRecognizerStateEnded.")
            buttonUp()
            buttonState = 2
        }
        else{ // Any slight movement in the finger holding it down will trigger this and it is very sensitive. As such, we put a buffer of 5 to ensure that this only triggers when the user swipes out of the button
            minimumAllowedMovements -= 1
            if minimumAllowedMovements == 0 && buttonState != 3{
                print("cancel")
                buttonState = 3
                TodayViewController.timeLeftLabel.text = "Cancelled"
                resetTimer()
            }
        }
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.newData)
    }
}
