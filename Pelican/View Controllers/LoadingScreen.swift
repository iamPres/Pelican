//
//  LoadingScreen.swift
//  Pelican
//
//  Created by Preston Willis on 3/14/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

/*
 The LoadingScreen downloads all content and saves the title and thumbnail of
 each URL to storage so the ArticleListScreen can stay loaded at all times. It also
 initializes initial nightmode settings and bookmarking data matrices if neccessary.
 */

import UIKit
import Alamofire
import SwiftSoup

class LoadingScreen: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var header: UIView!
    
    let notification = UINotificationFeedbackGenerator()
    var images: [Data?] = [] // ArticleListScreen thumbnail images
    var titles: [String] = [] // ArticleListScreen titles
    var isSegued: Bool = false
    var timeout: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "isSegued")
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        // Init. Nightmode state
        if (UserDefaults.standard.object(forKey: "nightmode") == nil) {
            UserDefaults.standard.set(false, forKey: "nightmode")
        }
        
        setNightView()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Download all data (Multithreading..)
        if UserDefaults.standard.object(forKey: "isSegued") as! Bool != true {
            UserDefaults.standard.set(true, forKey: "isSegued")
            
            // Init. ArticleListScreen
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArticleListScreen") as? ArticleListScreen
            
            // Init. ArticleListScreen thumbnail and title matrices
            for _ in 0..<((vc?.url.count)!) {
                images.append(nil)
                titles.append("")
            }
            
            for i in 0..<((vc?.url.count)!) {
                vc?.parseHTML(index: i) { result in
                    
                    // Retreive titles
                    var attribute: String = ""
                    do{
                        let doc: Document = try SwiftSoup.parse(result)
                        try attribute = doc.getElementsByClass("post-headline ").text()
                        NSLog("Loaded attribute: "+String(i))
                    }catch{
                        NSLog("None")
                    }
                    self.titles[i] = attribute
                    
                    // Retreive image data
                    do{
                        let doc: Document = try SwiftSoup.parse(result)
                        try attribute = doc.getElementsByTag("img").attr("src")
                        NSLog("     Image: "+String(i))
                    }catch{
                        NSLog("None")
                    }
                    vc?.getData(from: URL.init(string: attribute)!) { data, response, error  in
                        self.images[i] = data!
                   }
                }
            }
             test()
        }
        
        // Check to see if all content is downloaded
    }
    
    func test(){
        timeout += 1
        // Wait 0.5s in a seperate thread (Max 10s)
        if timeout <= 20 {
            
            UserDefaults.standard.set(false, forKey: "timedout")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.titles.contains("") || self.images.contains(nil){
                    self.test()
                }
                else{
                    //If all content loaded, proceed to prepare(), else test()
                    NSLog(" ---------------------------- ")
                    NSLog(" All attributes loaded.. Prepare to segue." )
                    self.performSegue(withIdentifier: "segue1", sender: nil)
                }
            }
        }
        else{
            // Timeout after 10s
            UserDefaults.standard.set(true, forKey: "timedout")
            
            NSLog(" ---------------------------- ")
            NSLog(" Timed out.. Prepare to segue." )
            
            self.performSegue(withIdentifier: "segue1", sender: nil)
        }
    }
    
    func setNightView(){
        // Nightmode setings
        NSLog("ran")
        if SettingsTableViewController().changeColor(target: self, labels: [label]) {
            loading.color = UIColor.white
            self.view.viewWithTag(2)?.backgroundColor = SettingsTableViewController().darkBackground
            menuButton.setImage(#imageLiteral(resourceName: "menu-button-of-three-horizontal-lines-white.png"), for: UIControl.State.normal)
        }
        else {
            loading.color = UIColor.black
            self.view.viewWithTag(2)?.backgroundColor = SettingsTableViewController().lightColor
            menuButton.setImage(#imageLiteral(resourceName: "menu-button-of-three-horizontal-lines.png"), for: UIControl.State.normal)
        }
    }
    
    func setConstraints(){
        if UIScreen.main.fixedCoordinateSpace.bounds.height == 667 || UIScreen.main.fixedCoordinateSpace.bounds.height == 736{
            self.header.addConstraint(NSLayoutConstraint(item: self.header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:50))
        }
        else {
            self.header.addConstraint(NSLayoutConstraint(item: self.header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:UIScreen.main.fixedCoordinateSpace.bounds.height*1/10))
        }
    }

    // Called before ArticleListScreen loads
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! ArticleListScreen
        var imageData: [NSData] = []
        
        // If everything loaded, set attributes. Else, present nothing.
        if UserDefaults.standard.object(forKey: "timedout") as! Bool == false{
            
             NSLog(" ---------------------------- ")
            
            for i in 0..<(vc.url.count) {
                imageData.append(images[i] as! NSData)
            }
        }
        else {
            for _ in 0..<(vc.url.count) {
                imageData.append(#imageLiteral(resourceName: "output-onlinepngtools.png").pngData()! as NSData)
            }
        }
        
        // If bookmark state matrix doesnt exist, make it
        if (UserDefaults.standard.array(forKey: "bookmarkArray") == nil) {
        var array: [Bool] = []
            for _ in 0..<(vc.url.count) {
                    // Set all bookmarks to false
                    array.append(false)
            }
        // Save bookmark matrix to storage
            UserDefaults.standard.set(array, forKey: "bookmarkArray")
        }
        // Save titles and thumbnails to storage
        UserDefaults.standard.set(imageData, forKey: "images")
        UserDefaults.standard.set(self.titles, forKey: "titles")
        UserDefaults.standard.synchronize()
        
        notification.notificationOccurred(.success)
    }

}
