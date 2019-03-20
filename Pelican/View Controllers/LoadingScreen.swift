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
    var images: [UIImage] = [] // ArticleListScreen thumbnail images
    var titles: [String] = [] // ArticleListScreen titles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nightmode setings
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Init. ArticleListScreen
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArticleListScreen") as? ArticleListScreen
        
        // Init. Nightmode state
        if (UserDefaults.standard.object(forKey: "nightmode") == nil) {
            UserDefaults.standard.set(false, forKey: "nightmode")
        }
        
        // Init. ArticleListScreen thumbnail and title matrices
        for _ in 0..<((vc?.url.count)!) {
            images.append(UIImage.init())
            titles.append("")
        }
        
        // Download all data (Multithreading..)
        for i in 0..<((vc?.url.count)!) {
            vc?.parseHTML(index: i) { result in
                
                // Retreive titles
                var attribute: String = ""
                do{
                    let doc: Document = try SwiftSoup.parse(result)
                    try attribute = doc.getElementsByClass("post-headline ").text()
                    NSLog("NEW SHIT: "+attribute)
                }catch{
                    NSLog("None")
                }
                self.titles[i] = attribute
                
                // Retreive image data
                do{
                    let doc: Document = try SwiftSoup.parse(result)
                    try attribute = doc.getElementsByTag("img").attr("src")
                    NSLog(attribute)
                }catch{
                    NSLog("None")
                }
                vc?.getData(from: URL.init(string: attribute)!) { data, response, error  in
                    self.images[i] = (UIImage(data: data!)!)
               }
            }
        }
        
        // Check to see if all content is downloaded
        test()
    }
    
    func test(){
        
        //Wait 0.5s (Separate thread)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            //If all content loaded, proceed to prepare(), else test()
            if (self.titles.contains("")){
                self.test()
            }
            else{
                self.performSegue(withIdentifier: "segue1", sender: nil)
            }
        }
    }

    // Called before ArticleListScreen loads
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = segue.destination as! ArticleListScreen
        var imageData: [NSData] = []
        for i in 0..<(images.count) {
            imageData.append(images[i].pngData()! as NSData)
        }
        
        // If bookmark state matrix doesnt exist, make it
        if (UserDefaults.standard.array(forKey: "bookmarkArray") == nil) {
        var array: [Bool] = []
            for _ in 0..<(images.count) {
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
    }

}
