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
    @IBOutlet weak var scrollView: ScrollView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var author: UILabel!
    var url: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if SettingsTableViewController().changeColor(target: self, labels: [article, headline, date, author]) {
            frame.backgroundColor = UIColor(red: 0.1,green: 0.0,blue: 0.1,alpha: 1.0)
        }
        else {
            frame.backgroundColor = UIColor.white
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
                self.image.contentMode = .scaleAspectFit
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

            do{
                let doc: Document = try SwiftSoup.parse(result)
                try attribute = doc.getElementsByClass("post-content typography ").text()
                NSLog("NEW SHIT: "+attribute)
            }catch{
                NSLog("None")
            }
            self.article.text = attribute
            self.article.sizeToFit()
            
            self.frame.addConstraint(NSLayoutConstraint(item: self.frame, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.article.frame.size.height+self.headline.frame.size.height+200))
            
            self.scrollView.addConstraint(NSLayoutConstraint(item: self.frame, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:self.article.frame.size.height+self.headline.frame.size.height+self.image.frame.height+200))

            do{
                let doc: Document = try SwiftSoup.parse(result)
                try attribute = doc.getElementsByClass("byline-timestamp").text()
                NSLog("NEW SHIT: "+attribute)
            }catch{
                NSLog("None")
            }
            self.date.text = attribute

            do{
                let doc: Document = try SwiftSoup.parse(result)
                try attribute = doc.getElementsByClass("byline-link byline-author-name").text()
                NSLog("NEW SHIT: "+attribute)
            }catch{
                NSLog("None")
            }
            self.author.text = attribute
        }
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func parseHTML( completionHandler: @escaping (String) -> Void){
        Alamofire.request(url!).responseString { response in
            if let html: String = response.result.value {
                //NSLog(html)
                completionHandler(html)
            }
        }
    }
}
