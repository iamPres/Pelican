//
//  ArticleListScreen.swift
//  Pelican
//
//  Created by Preston Willis on 3/9/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

import UIKit
import SwiftSoup
import Alamofire

class ArticleListScreen: UIViewController {
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var index: Int = 0
    var titles: [String] = []
    var images: [UIImage] = []
    var loaded: Int = 0
    let url: [URL] = [URL(string: "https://www.businessinsider.com/amazon-web-services-open-source-elasticsearch-2019-3")!,
                      URL(string: "https://www.businessinsider.com/zero-electric-motorcycle-brings-connectivity-race-for-e-bikes-2019-3")!,
                      URL(string: "https://www.businessinsider.com/lyft-ipo-public-s-1-filing-details-2019-2")!,
                      URL(string: "https://www.businessinsider.com/most-powerful-countries-ranked-us-news-and-world-report-2019-2")!,
                      URL(string: "https://www.businessinsider.com/highest-paying-job-in-every-us-state-2019-2")!,
                      URL(string: "https://www.businessinsider.com/theresa-may-defeated-on-eu-brexit-deal-meaningful-vote-for-second-time-2019-3")!]

    override func viewDidLoad() {
        super.viewDidLoad()
        if SettingsTableViewController().changeColor(target: self, labels: [label]) {
            self.view.viewWithTag(2)?.backgroundColor = SettingsTableViewController().darkBackground
                menuButton.setImage(#imageLiteral(resourceName: "menu-button-of-three-horizontal-lines-white.png"), for: UIControl.State.normal)
        }
        else {
             self.view.viewWithTag(2)?.backgroundColor = SettingsTableViewController().lightColor
                menuButton.setImage(#imageLiteral(resourceName: "menu-button-of-three-horizontal-lines.png"), for: UIControl.State.normal)
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.title == "ArticleViewController" {
            let vc = segue.destination as! ArticleViewController
            vc.url = url[index]
            vc.count = index
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func parseHTML(index: Int, completionHandler: @escaping (String) -> Void){
        Alamofire.request(url[index]).responseString { response in
            if let html: String = response.result.value {
                completionHandler(html)
            }
        }
    }
}

extension ArticleListScreen: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return url.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") as! ArticleCell
        if(indexPath.row == 0){
            tableView.rowHeight = 90
            tableView.separatorStyle = .singleLine
        }
        else if (indexPath.row == 5){
            tableView.separatorStyle = .none
        }
        else{
            tableView.rowHeight = 90
        }
        if loaded < url.count {
            loaded += 1
        cell.thumbnail.contentMode = .scaleAspectFit
        cell.thumbnail.image = UIImage(data: (UserDefaults.standard.array(forKey: "images")![indexPath.row] as! NSData) as Data)
        cell.titleLabel.text = UserDefaults.standard.array(forKey: "titles")![indexPath.row] as? String
        }
        if SettingsTableViewController().changeColor(target: self, labels: [cell.titleLabel]) {
        cell.backgroundColor = SettingsTableViewController().darkBackground
        tableView.separatorColor = UIColor.darkGray
        }
        else {
        cell.backgroundColor = SettingsTableViewController().lightColor
        tableView.separatorColor = UIColor.lightGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("SELECTED"+String(indexPath.row))
        index = indexPath.row
        self.performSegue(withIdentifier: "segue2", sender: nil)
    }
}

