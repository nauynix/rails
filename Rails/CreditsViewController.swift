//
//  CreditsViewController.swift
//  Rails
//
//  Created by Feng Xinyuan on 1/8/17.
//  Copyright © 2017 nyx. All rights reserved.
//

import UIKit
import FAQView

class CreditsViewController: UIViewController {
    
    @IBOutlet weak var xyview: UIView!
    override func viewDidLoad() {
        navigationItem.title = "Licenses & Credits"
        super.viewDidLoad()
        let items = [
            FAQItem(question: "Paper-onboarding", answer: "Project: https://github.com/Ramotion/paper-onboarding\n\nThe MIT License (MIT)\n\nCopyright (c) 2016 Ramotion\n\nPermission is hereby granted, free of charge, to any person obtaining a copyof this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."),
            
            FAQItem(question: "Ios-charts", answer: "Project: https://github.com/danielgindi/Charts"),
            
            FAQItem(question: "Location", answer: "Project: https://github.com/voyage11/Location"),
            
            FAQItem(question: "Permision scope", answer: "Project: https://github.com/nickoneill/PermissionScope\n\nThe MIT License (MIT)\n\nCopyright (c) 2016 nickoneill\n\nPermission is hereby granted, free of charge, to any person obtaining a copyof this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."),
            
            FAQItem(question: "TTGSnackbar", answer: "Project: https://github.com/zekunyan/TTGSnackbar"),
            
            FAQItem(question: "FAQView", answer: "Project: https://github.com/mukeshthawani/FAQView\n\nThe MIT License (MIT)\n\nCopyright (c) 2016 Mukesh Thawani\n\nPermission is hereby granted, free of charge, to any person obtaining a copyof this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."),
            
            FAQItem(question: "Icons", answer: "clock by Taylor Medlin from the Noun Project\nRocket Take Off by MRFA from the Noun Project\ngrowth by Milan Gladiš from the Noun Project\nRace Track by Liau Jian Jie from the Noun Project\nTarget by Francesco Terzini from the Noun Project\nsand clock by bezier master from the Noun Project"),
            
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
