//
//  ArticleViewController.swift
//  Pelican
//
//  Created by Preston Willis on 3/10/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

 /*
 ArticleViewController loads / writes / purges article data
 from storage based on bookmarked state. It also scrapes article content
 from a URL passed from ArticleListScreen if not bookmarked.
 */

import UIKit
import SwiftSoup
import Alamofire

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var article: UILabel!
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var frame: Frame! // Rounded article border
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    let impact = UIImpactFeedbackGenerator(style: .heavy)
    let Nightmode_class = Nightmode()
    
    let indent = "      "
    var data: Data? // Image data
    var url: URL? = nil // URL to scrape
    var count: Int = 0 // Article index for storing data
    var result: [String] = [] // Contents of article
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        /*
         When the bookmark button is pressed, load the corresponding image and log the article
        contents to storage. If the page was already bookmarked, remove the contents from storage.
         
         - "bookmarkArray" holds an array of boolean values correcponding to the boolean bookmarked state of each page
         - "html" holds the elements of each article
         - "image" holds the raw data of each thumbnail image
         */
        
        impact.impactOccurred()
        
        if (UserDefaults.standard.array(forKey: "bookmarkArray")![count] as! Bool == true) {
            if (UserDefaults.standard.object(forKey: "nightmode") as! Bool == true) {
                
                self.button.setImage(#imageLiteral(resourceName: "bookmark-outline-white.png"), for: UIControl.State.normal)
                
                var array = UserDefaults.standard.array(forKey: "bookmarkArray") as? [Bool]
                array![count] = false
                UserDefaults.standard.set(array, forKey: "bookmarkArray")
                UserDefaults.standard.set(nil, forKey: "html"+String(count))
                UserDefaults.standard.set(nil, forKey: "image"+String(count))
            }
            else if (UserDefaults.standard.object(forKey: "nightmode") as! Bool == false) {
                
                self.button.setImage(#imageLiteral(resourceName: "bookmark-outline.png"), for: UIControl.State.normal)
                
                var array: [Bool] = UserDefaults.standard.array(forKey: "bookmarkArray") as! [Bool]
                array[count] = false
                UserDefaults.standard.set(array, forKey: "bookmarkArray")
                UserDefaults.standard.set(nil, forKey: "html"+String(count))
                UserDefaults.standard.set(nil, forKey: "image"+String(count))
            }
        }
        else if (UserDefaults.standard.array(forKey: "bookmarkArray")![count] as! Bool == false) {
            if (UserDefaults.standard.object(forKey: "nightmode") as! Bool == true) {
                
                self.button.setImage(#imageLiteral(resourceName: "image.png"), for: UIControl.State.normal)
                
                var array = UserDefaults.standard.array(forKey: "bookmarkArray") as? [Bool]
                array![count] = true
                UserDefaults.standard.set(array, forKey: "bookmarkArray")
                UserDefaults.standard.set(result, forKey: "html"+String(count))
                UserDefaults.standard.set(data, forKey: "image"+String(count))
            }
            else if (UserDefaults.standard.object(forKey: "nightmode") as! Bool == false) {
                
                self.button.setImage(#imageLiteral(resourceName: "bookmark.png"), for: UIControl.State.normal)
                
                var array = UserDefaults.standard.array(forKey: "bookmarkArray") as? [Bool]
                array![count] = true
                UserDefaults.standard.set(array, forKey: "bookmarkArray")
                UserDefaults.standard.set(result, forKey: "html"+String(count))
                UserDefaults.standard.set(data, forKey: "image"+String(count))
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNightMode()
        
        // If the page is bookmarked, load contents from storage
        if (UserDefaults.standard.array(forKey: "bookmarkArray")![count] as! Bool == true && UserDefaults.standard.object(forKey: "image"+String(count)) != nil) {
            result = UserDefaults.standard.array(forKey: "html"+String(count)) as! [String]
            
            headline.text = result[0]
            article.text = indent+result[1]
            date.text = result[2]
            author.text = result[3]
            image.image = UIImage(data: UserDefaults.standard.object(forKey: "image"+String(count)) as! Data)
    
            format()
            setButton()
        }
            
        // Else, scrape content from the web
        else {
            loadContent()
        }
    }
    
    func setNightMode(){
        // Nightmode settings
        if Nightmode_class.changeColor(target: self, labels: [article, headline, date, author]) {
            frame.backgroundColor = Nightmode_class.darkBackground
        }
        else {
            frame.backgroundColor = Nightmode_class.lightColor
        }
    }
    
    func loadContent() {
        
        // Init. static array
        for _ in 0...4 {
            result.append("")
        }

        // Alamofire completion handler (Separate thread)
        parseHTML() { result in
            var attribute: String = ""
            do{
                // Load attribute by tag with SwiftSoup
                let doc: Document = try SwiftSoup.parse(result)
                try attribute = doc.getElementsByTag("img").attr("src")
                NSLog(attribute)
            }catch{
                NSLog("None")
            }
            // Load image (Separate thread)
            self.getData(from: URL.init(string: attribute)!) { data, response, error  in
                self.data = data
                self.image.image = UIImage(data: data!)
            }
            
            do{
                let doc: Document = try SwiftSoup.parse(result)
                try attribute = doc.getElementsByClass("post-headline ").text()
                NSLog("NEW SHIT: "+attribute)
            }catch{
                NSLog("None")
            }
            self.headline.text = attribute
            self.result[0] = attribute
            
            do{
                let doc: Document = try SwiftSoup.parse(result)
                try attribute = doc.getElementsByClass("post-content typography ").text()
                NSLog("NEW SHIT: "+attribute)
            }catch{
                NSLog("None")
            }
            
            self.article.text = self.indent+attribute
            self.result[1] = attribute
            
            self.setButton()
            self.format()
            
            do{
                let doc: Document = try SwiftSoup.parse(result)
                try attribute = doc.getElementsByClass("byline-timestamp").text()
                NSLog("NEW SHIT: "+attribute)
            }catch{
                NSLog("None")
            }
            self.date.text = attribute
            self.result[2] = attribute
            
            do{
                let doc: Document = try SwiftSoup.parse(result)
                try attribute = doc.getElementsByClass("byline-link byline-author-name").text()
                NSLog("NEW SHIT: "+attribute)
            }catch{
                NSLog("None")
            }
            self.author.text = attribute
            self.result[3] = attribute
        }
        
    }
    
    // Set constraints
    func format () {
        self.article.sizeToFit()
        
        // Width == screen width
          self.frame.addConstraint(NSLayoutConstraint(item: self.frame, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:UIScreen.main.fixedCoordinateSpace.bounds.width))
        
        // Width == screen width
        self.frame.addConstraint(NSLayoutConstraint(item: self.frame, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:UIScreen.main.fixedCoordinateSpace.bounds.width))
        
        // Image height == aspect fit
        //self.image.addConstraint(NSLayoutConstraint(item: self.image, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:UIScreen.main.fixedCoordinateSpace.bounds.width * (self.image.image?.size.height)! / (self.image.image?.size.width)!))
        
        // Image height == 1/3 screen height
        self.image.addConstraint(NSLayoutConstraint(item: self.image, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.height/3))
        
        // Scroll View content == article + headline + constant
        self.scrollView.contentSize = CGSize(width: 375, height: self.article.frame.size.height+self.headline.frame.size.height+150)
        
        // Frame height == Scroll View content size
        self.frame.addConstraint(NSLayoutConstraint(item: self.frame, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:self.article.frame.size.height+self.headline.frame.size.height+150))
    }
    
    // Set button state on load (Load corresponding image)
    func setButton() {
        if (UserDefaults.standard.array(forKey: "bookmarkArray")![count] as! Bool == true) {
            if (UserDefaults.standard.object(forKey: "nightmode") as! Bool == true) {
                self.button.setImage(#imageLiteral(resourceName: "image.png"), for: UIControl.State.normal)
            }
            else if (UserDefaults.standard.object(forKey: "nightmode") as! Bool == false) {
                self.button.setImage(#imageLiteral(resourceName: "bookmark.png"), for: UIControl.State.normal)
            }
        }
        else if (UserDefaults.standard.array(forKey: "bookmarkArray")![count] as! Bool == false) {
            if (UserDefaults.standard.object(forKey: "nightmode") as! Bool == true) {
                self.button.setImage(#imageLiteral(resourceName: "bookmark-outline-white.png"), for: UIControl.State.normal)
            }
            else if (UserDefaults.standard.object(forKey: "nightmode") as! Bool == false) {
                self.button.setImage(#imageLiteral(resourceName: "bookmark-outline.png"), for: UIControl.State.normal)
            }
        }
    }
    
    // Download image data
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // Download html
    func parseHTML( completionHandler: @escaping (String) -> Void){
        Alamofire.request(url!).responseString { response in
            if let html: String = response.result.value {
                completionHandler(html)
            }
        }
    }
}
