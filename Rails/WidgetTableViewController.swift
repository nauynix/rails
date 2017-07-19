//
//  DataTableViewController.swift
//  TableExample
//
//  Created by Ralf Ebert on 19/09/16.
//  Copyright © 2016 Example. All rights reserved.
//

import UIKit

class WidgetTableViewController: UITableViewController {
    let defaults = UserDefaults.init(suiteName: "group.nauynix.rails")
    var allApps:[String] = ["BBC", "Facebook", "Instagram", "Quora", "Reddit", "Whatsapp", "Youtube", "9GAG", "Clash Of Clans", "Google+", "Messenger", "Netflix", "Pinterest", "Snapchat", "Twitter", "WeChat"]
    var selectedApps:[String] = []
    var notSelectedApps:[String] = []
    let appImageDictionary:[String:UIImage] = ["BBC":UIImage(named: "bbc")!, "Facebook":UIImage(named: "facebook")!, "Instagram":UIImage(named: "instagram")!, "Quora":UIImage(named: "quora")!, "Reddit":UIImage(named: "reddit")!, "Whatsapp":UIImage(named: "whatsapp")!, "Youtube":UIImage(named: "youtube")!, "9GAG":UIImage(named: "9gag")!, "Clash Of Clans":UIImage(named: "clashofclans")!, "Google+":UIImage(named: "google+")!, "Messenger":UIImage(named: "messenger")!, "Netflix":UIImage(named: "netflix")!, "Pinterest":UIImage(named: "pinterest")!, "Snapchat":UIImage(named: "snapchat")!, "Twitter":UIImage(named: "twitter")!, "WeChat":UIImage(named: "wechat")!]
    //private let appUrlDictionary: [String:Url] = ["BBC":URL(string: "bbcnewsapp://")!, "Facebook":URL(string: "fb://")!, "Instagram":URL(string: "instagram://")!, "Quora":URL(string: "quora://")!, "Reddit":URL(string: "reddit://")!, "Whatsapp":URL(string: "whatsapp://")!, "Youtube":URL(string: "youtube://")!]
    private let appUrlDictionary: [String:String] = ["BBC":"bbcnewsapp://", "Facebook":"fb://", "Instagram":"instagram://", "Quora":"quora://", "Reddit":"reddit://", "Whatsapp":"whatsapp://", "Youtube":"youtube://","9GAG":"ninegag://","Clash Of Clans":"clashofclans://","Google+":"gplus://","Messenger":"fb-messenger://","Netflix":"nflx://","Pinterest":"pinterest://","Snapchat":"snapchat://","Twitter":"twitter://","WeChat":"wechat://"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isEditing = true
        defaults?.removeObject(forKey: "selectedAppsString")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if defaults?.array(forKey: "selectedAppsString") != nil{
            selectedApps = defaults?.array(forKey: "selectedAppsString") as! [String]
            // Remove the "Others" in the array: selectedApps contains [List of Apps at most 7] while the userdefaults key "selectedAppsString" contains  [List of Apps at most 7, "Others"]
            selectedApps.removeLast()
            notSelectedApps = defaults?.array(forKey: "notSelectedAppsString") as! [String]
            
            // Check if there are any new apps
            // Used a dictionary for ease of removing
            var appsThatExistInPhone:[String:Int] = [:]
            for i in 0..<allApps.count{
                if UIApplication.shared.canOpenURL(URL(string: appUrlDictionary[allApps[i]]!)!){ // App exist in phone
                    // Number '0' does not matter here
                    appsThatExistInPhone[allApps[i]] = 0
                }
            }
            
            // Remove existing apps
            for i in 0..<selectedApps.count{
                appsThatExistInPhone.removeValue(forKey: selectedApps[i])
            }
            for i in 0..<notSelectedApps.count{
                appsThatExistInPhone.removeValue(forKey: notSelectedApps[i])
            }
            
            // appsThatExistInPhone should now only contain new apps. Add this new apps to the list of not selected apps
            for appNames in appsThatExistInPhone.keys{
                print("HEYYYY\(appNames)")
                notSelectedApps.append(appNames)
            }
            
            // Check if there are any deleted apps
            // Reverse order to prevent iterator from accessing outside range
            for i in (0..<selectedApps.count).reversed(){
                if UIApplication.shared.canOpenURL(URL(string: appUrlDictionary[selectedApps[i]]!)!) == false{ // App no longer exist in phone
                    selectedApps.remove(at: i)
                }
            }
            for i in (0..<notSelectedApps.count).reversed(){
                if UIApplication.shared.canOpenURL(URL(string: appUrlDictionary[notSelectedApps[i]]!)!) == false{ // App no longer exist in phone
                    notSelectedApps.remove(at: i)
                }
            }
            
        }
        else{ // The first time the app is ran
            selectedApps.removeAll()
            notSelectedApps.removeAll()
            for i in 0..<allApps.count{
                if UIApplication.shared.canOpenURL(URL(string: appUrlDictionary[allApps[i]]!)!){ // App exist in phone
                    if selectedApps.count < 7{ // Put it in selected
                        selectedApps.append(allApps[i])
                    }
                    else{ // Put it in not selected
                        notSelectedApps.append(allApps[i])
                    }
                }
            }
        }
        update()
        self.tableView.reloadData()
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let size = image.size.applying(CGAffineTransform(scaleX: 0.4, y: 0.4))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    // MARK: HeaderTableView
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }
    
    func sizeHeaderToFit() {
        // Dynamic sizing for the header view
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            
            // If we don't have this check, viewDidLayoutSubviews() will get
            // repeatedly, causing the app to hang.
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }
    }

    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0     {
            return selectedApps.count
        }
        else{
            return notSelectedApps.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if section == 0     {
            return "\(selectedApps.count)/7"
        }
        else{
            return "More Apps"
        }

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = selectedApps[indexPath.row]
            cell.imageView?.image = resizeImage(image: appImageDictionary[(cell.textLabel?.text)!]!, newWidth: 30)
            cell.imageView?.layer.cornerRadius = 5
            cell.imageView?.layer.masksToBounds=true
            cell.imageView?.layer.borderWidth=0.1
        }
        else{
            cell.textLabel?.text = notSelectedApps[indexPath.row]
            cell.imageView?.image = resizeImage(image: appImageDictionary[(cell.textLabel?.text)!]!, newWidth: 30)
            cell.imageView?.layer.cornerRadius = 5
            cell.imageView?.layer.masksToBounds=true
            cell.imageView?.layer.borderWidth=0.1
        }

        
        return cell
    }
    
    // MARK: - Sorting
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 0 {
            return .delete
        }
        else if selectedApps.count < 7{ // Check that there are lesser than 7 apps before giving cells the option to be inserted into app list
            return .insert
        }
        else{
            return .none
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 // Only allow the first section to be reorderable while the second section is not
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { // Remove cell from app list and add it to more apps
            let movedObject = selectedApps[indexPath.row]
            selectedApps.remove(at: indexPath.row)
            notSelectedApps.append(movedObject)
            notSelectedApps.sort()
        }
        if editingStyle == .insert { // Remove cell from more apps and add it into app list
            let movedObject = notSelectedApps[indexPath.row]
            notSelectedApps.remove(at: indexPath.row)
            selectedApps.append(movedObject)
        }
        self.tableView.reloadData()
        update()
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject:String
        if sourceIndexPath.section == 0 {
            movedObject = selectedApps[sourceIndexPath.row]
            selectedApps.remove(at: sourceIndexPath.row)
        }
        else{
            movedObject = notSelectedApps[sourceIndexPath.row]
            notSelectedApps.remove(at: sourceIndexPath.row)
        }
        if destinationIndexPath.section == 0 {
            selectedApps.insert(movedObject, at: destinationIndexPath.row)
        }
        else{
            notSelectedApps.insert(movedObject, at: destinationIndexPath.row)
        }
        notSelectedApps.sort()
        // NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(fruits)")*/
        // To check for correctness enable: self.tableView.reloadData()
        self.tableView.reloadData()
        update()
    }
    
    // MARK: Private methods
    func update(){ // For TodayViewController in Rails Widget to access
        // Append the others icon to the last of all three arrays
        var selectedStrings = selectedApps
        selectedStrings.append("Others")
        var selectedImages:[UIImage] = []
        for i in 0..<selectedApps.count{
            selectedImages.append(appImageDictionary[selectedApps[i]]!)
        }
        selectedImages.append(UIImage(named: "others")!)
        var selectedURL:[String] = []
        for i in 0..<selectedApps.count{
            selectedURL.append(appUrlDictionary[selectedApps[i]]!)
        }
        selectedURL.append("nil") // To signal that there is no need to launch an app
        defaults?.set(selectedStrings, forKey: "selectedAppsString")
        defaults?.set(notSelectedApps, forKey: "notSelectedAppsString")
        defaults?.set(selectedURL, forKey: "selectedAppsURL")
        for i in 0..<selectedImages.count{
            let imageData = UIImagePNGRepresentation(selectedImages[i])
            defaults?.set(imageData, forKey: "image\(i)")
        }
        defaults?.set(selectedImages.count, forKey: "numberOfImages")
    }
}
/*
extension UserDefaults {
    func set(image: UIImage?, forKey key: String) {
        guard let image = image else {
            set(nil, forKey: key)
            return
        }
        set(UIImageJPEGRepresentation(image, 1.0), forKey: key)
    }
    func image(forKey key:String) -> UIImage? {
        guard let data = data(forKey: key), let image = UIImage(data: data )
            else  { return nil }
        return image
    }
    func set(imageArray value: [UIImage]?, forKey key: String) {
        guard let value = value else {
            set(nil, forKey: key)
            return
        }
        set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key)
    }
    func imageArray(forKey key:String) -> [UIImage]? {
        guard  let data = data(forKey: key),
            let imageArray = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UIImage]
            else { return nil }
        return imageArray
    }
}*/
