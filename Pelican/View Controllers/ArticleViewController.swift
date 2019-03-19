//
//  ArticleViewController.swift
//  Pelican
//
//  Created by Preston Willis on 3/10/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

import UIKit
import SwiftSoup
import Alamofire

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var article: UILabel!
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var frame: Frame!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    var data: Data?
    var url: URL? = nil
    var count: Int = 0
    var result: [String] = []
    
    @IBAction func buttonAction(_ sender: UIButton) {
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
        
        if SettingsTableViewController().changeColor(target: self, labels: [article, headline, date, author]) {
            frame.backgroundColor = UIColor(red: 0.1,green: 0.0,blue: 0.1,alpha: 1.0)
        }
        else {
            frame.backgroundColor = UIColor.white
        }
        
        if (UserDefaults.standard.array(forKey: "bookmarkArray")![count] as! Bool == true && UserDefaults.standard.object(forKey: "image"+String(count)) != nil) {
            result = UserDefaults.standard.array(forKey: "html"+String(count)) as! [String]
            headline.text = result[0]
            article.text = result[1]
            date.text = result[2]
            author.text = result[3]
            image.image = UIImage(data: UserDefaults.standard.object(forKey: "image"+String(count)) as! Data)
            format()
            setButton()
        }
        else {
            loadContent()
        }
    }
    
    func loadContent() {
        
        for _ in 0...4 {
            result.append("")
        }

        parseHTML() { result in
            var attribute: String = ""
            do{
                let doc: Document = try SwiftSoup.parse(result)
                try attribute = doc.getElementsByTag("img").attr("src")
                NSLog(attribute)
            }catch{
                NSLog("None")
            }
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
            
            self.setButton()
            
            self.article.text = attribute
            self.result[1] = attribute
            
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
    
    func format () {
        self.article.sizeToFit()
        
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:UIScreen.main.fixedCoordinateSpace.bounds.width))
        
        self.frame.addConstraint(NSLayoutConstraint(item: self.frame, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:UIScreen.main.fixedCoordinateSpace.bounds.width))
        
        self.image.addConstraint(NSLayoutConstraint(item: self.image, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:UIScreen.main.fixedCoordinateSpace.bounds.height*1/3))
        
        self.scrollView.contentSize = CGSize(width: 375, height: self.article.frame.size.height+self.headline.frame.size.height+150)
        
        self.frame.addConstraint(NSLayoutConstraint(item: self.frame, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:self.article.frame.size.height+self.headline.frame.size.height+150))
    }
    
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
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func parseHTML( completionHandler: @escaping (String) -> Void){
        Alamofire.request(url!).responseString { response in
            if let html: String = response.result.value {
                completionHandler(html)
            }
        }
    }
}
