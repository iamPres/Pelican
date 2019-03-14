//
//  LoadingScreen.swift
//  Pelican
//
//  Created by Preston Willis on 3/14/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup

class LoadingScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var images: [UIImage] = []
    var titles: [String] = []
    
    override func viewDidAppear(_ animated: Bool) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArticleListScreen") as? ArticleListScreen
        
        for _ in 0..<((vc?.url.count)!) {
            images.append(UIImage.init())
            titles.append("")
        }
        
        for i in 0..<((vc?.url.count)!) {
            vc?.parseHTML(index: i) { result in
                var attribute: String = ""
                do{
                    let doc: Document = try SwiftSoup.parse(result)
                    try attribute = doc.getElementsByClass("post-headline ").text()
                    NSLog("NEW SHIT: "+attribute)
                }catch{
                    NSLog("None")
                }
                self.titles[i] = attribute
                
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

        test()
    }
    
    func test(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if (self.titles.contains("")){
                self.test()
            }
            else{
                self.performSegue(withIdentifier: "segue1", sender: nil)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ArticleListScreen
        var imageData: [NSData] = []
        for i in self.images {
            imageData.append(i.pngData()! as NSData)
        }
        UserDefaults.standard.set(imageData, forKey: "images")
        UserDefaults.standard.set(self.titles, forKey: "titles")
        UserDefaults.standard.synchronize()
    }

}
