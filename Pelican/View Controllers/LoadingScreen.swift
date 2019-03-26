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
    
    let Nightmode_class = Nightmode()
    let ArticleListScreen_class = ArticleListScreen()
    let notification = UINotificationFeedbackGenerator()
    var images: [Data?] = [] // ArticleListScreen thumbnail images
    var titles: [String] = [] // ArticleListScreen titles
    var isSegued: Bool = false
    var timeout: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData() // Init storage values
        
        if UserDefaults.standard.object(forKey: "isSegued") as! Bool != true {
            UserDefaults.standard.set(true, forKey: "isSegued")
            
            nightmodeSettings() // Nightmode settings
            setConstraints() // Set constraints
            
            downloadData() // Download all data (Multithreading..)
            test() // Test to see if data is downloaded
        }
        
        // Check to see if all content is downloaded
    }
    
    func downloadData() {
        for i in 0..<(ArticleListScreen_class.url.count) {
            ArticleListScreen_class.parseHTML(index: i) { result in
                
                // Retreive titles
                var attribute: String = ""
                do{
                    let doc: Document = try SwiftSoup.parse(result)
                    try attribute = doc.getElementsByClass("tagdiv-entry-title").text()
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
                self.ArticleListScreen_class.getData(from: URL.init(string: attribute)!) { data, response, error  in
                    self.images[i] = data!
                }
            }
        }
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
    
    func nightmodeSettings(){
        // Nightmode setings
        NSLog("ran")
        if Nightmode_class.changeColor(target: self, labels: [label]) {
            loading.color = UIColor.white
            self.view.viewWithTag(2)?.backgroundColor = Nightmode_class.darkBackground
            menuButton.setImage(#imageLiteral(resourceName: "menu-button-of-three-horizontal-lines-white.png"), for: UIControl.State.normal)
        }
        else {
            loading.color = UIColor.black
            self.view.viewWithTag(2)?.backgroundColor = Nightmode_class.lightColor
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
    
    func initData() {
        UserDefaults.standard.set(false, forKey: "didClickHeadline")
        UserDefaults.standard.set(false, forKey: "isSegued")
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        // Init. Nightmode state
        if (UserDefaults.standard.object(forKey: "nightmode") == nil) {
            UserDefaults.standard.set(false, forKey: "nightmode")
        }
        
        // If bookmark state matrix doesnt exist, make it
        if (UserDefaults.standard.array(forKey: "bookmarkArray") == nil) {
            var array: [Bool] = []
            for _ in 0..<(ArticleListScreen_class.url.count) {
                // Set all bookmarks to false
                array.append(false)
            }
            // Save bookmark matrix to storage
            UserDefaults.standard.set(array, forKey: "bookmarkArray")
        }
        
        // Init. ArticleListScreen thumbnail and title matrices
        for _ in 0..<(ArticleListScreen_class.url.count) {
            images.append(nil)
            titles.append("")
        }

    }

    // Called before ArticleListScreen loads
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Save titles and thumbnails to storage
        if UserDefaults.standard.object(forKey: "timedout") as! Bool == false {
            UserDefaults.standard.set(titles, forKey: "titles")
            UserDefaults.standard.set(images, forKey: "images")
        }
        
        notification.notificationOccurred(.success)
    }

}
