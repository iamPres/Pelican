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
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIButton!
    var images: [UIImage] = []
    var titles: [String] = []
    var count: Int = 0
    var array: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArticleListScreen") as? ArticleListScreen
        
        if (UserDefaults.standard.object(forKey: "nightmode") == nil) {
            UserDefaults.standard.set(false, forKey: "nightmode")
        }
        
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if (self.titles.contains("")){
                self.test()
            }
            else{
                self.performSegue(withIdentifier: "segue1", sender: nil)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = segue.destination as! ArticleListScreen
        var imageData: [NSData] = []
        for i in 0..<(images.count) {
            imageData.append(images[i].pngData()! as NSData)
        }
        
        if (UserDefaults.standard.object(forKey: "bookmarkArray") == nil) {
        var array: [Bool] = []
            for i in 0..<(images.count) {
                    UserDefaults.standard.set(false, forKey: String(i))
                    array.append(false)
            }
        UserDefaults.standard.set(array, forKey: "bookmarkArray")
        }
        
        UserDefaults.standard.set(imageData, forKey: "images")
        UserDefaults.standard.set(self.titles, forKey: "titles")
        UserDefaults.standard.synchronize()
    }

}
