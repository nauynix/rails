//
//  FAQViewController.swift
//  Rails
//
//  Created by Feng Xinyuan on 1/8/17.
//  Copyright © 2017 nyx. All rights reserved.
//

import UIKit
import FAQView

class FAQViewController: UIViewController {

    @IBOutlet weak var xyview: UIView!
    override func viewDidLoad() {
        navigationItem.title = "FAQ"
        super.viewDidLoad()
        let items = [
            FAQItem(question: "Why do you need my location?", answer: "We do not need your location, but the iOS system does.\n\nDue to limitations in the iOS system, location service needs to be enabled to ensure that the app stay ‘alive’ in the background. This ensures that the app will accurately send you notifications to stop using your phone. Your location will never be tracked or stored and it is only used for the app to work properly."),
            
            FAQItem(question: "What is this app for?", answer: "Rails aims to introduce responsible phone usage.\n\nAfter a long day, we all want to unwind by checking out the latest news, or play a few rounds of game. However, we sometimes lose track of time and end up using our phones for hours when we wanted to only briefly interact with it. This is even more prevalent with the introduction of endless scrolling, unlimited new content, and autoplay of suggestion videos. One solution is to delete these apps and not to use them at all, but there is a better solution that allows you to relax while remaining productive.\n\nInstead of discouraging you from totally using your phone, we believe that using your phone for any means is acceptable as long as you remain in control. The app encourages you to be conscious of why you are using your phone and how long you want to use it for. This ensures that you do not sidetrack from your goal and spend hours on games and the social media.\n\nStart by setting a timer in the widget app and the app will take care of the rest by reminding you to stop using your phone."),
            
            FAQItem(question: "Why are there so many notifications?", answer: "Whenever you turn on your phone, the app will send a notification after thirty seconds of usage to remind you to set a timer if you have yet to.\n\n Once the timer is up, the app will tell you to stop using your phone. If the phone is not shut off, the app will send a reminder to stop using your phone 30, 60 and 90 seconds after the timer is up."),
            
            FAQItem(question: "I want more time after my timer is up!", answer: "Sure! Just swipe down on any notification to set a snooze alarm."),
            
            FAQItem(question: "Will this app affect my battery life?", answer: "Not at all! The app does a minimal amount of processing while in the background to protect battery life. It is designed from the ground up to compute as efficiently as possible and we are confident that you will not see a dip in battery life. In fact, you will probably see an increase in battery life due to a decrease in phone usage."),
            
            FAQItem(question: "The app that I want is not listed!", answer: "We are sorry to hear that! Do send us the name of the app that you would like to use in the widget at troppussliar@gmail.com (that is railssupport reversed) and we will try to include it as soon as possible."),
            
            FAQItem(question: "Rails stopped sending me notifications!", answer: "This can happen for a variety of reasons. The most common issue is that the app was terminated when it was swiped up in the multitasking menu. Although Rails is able to automatically resume tracking in certain situations, it is recommended that the app is never terminated so that it can function properly. Please be assured that the app will not take up any memory and slow your phone down."),
            
            FAQItem(question: "Need more help?", answer: "Contact us at troppussliar@gmail.com (that is railssupport reversed)")
            
            ]// View background color
        
        let faqView = FAQView(frame: view.frame, title: "FAQ", items: items)
        //let faqView = FAQView(frame: view.frame, items: items)
        
        
        // Question text font
        faqView.questionTextFont = UIFont.init(name: "AvenirNext-DemiBold", size: 17)!
        
        faqView.answerTextFont = UIFont.init(name: "AvenirNext-Regular", size: 14)!
        
        // View background color
        faqView.viewBackgroundColor = UIColor.white
        
        // Set up data detectors for automatic detection of links, phone numbers, etc., contained within the answer text.
        faqView.dataDetectorTypes = [.phoneNumber, .calendarEvent, .link]
        
        // Set color for links and detected data
        faqView.tintColor = UIColor(red: 36/255, green: 168/255, blue: 54/255, alpha: 1)
        
        xyview.addSubview(faqView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
