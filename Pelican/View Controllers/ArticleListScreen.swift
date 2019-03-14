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
    
    var index: Int = 0
    @IBOutlet weak var label: UILabel!
    var titles: [String] = ["","","","","",""]
    var images: [UIImage] = [#imageLiteral(resourceName: "polititian.jpg"),#imageLiteral(resourceName: "outside-page.png"),#imageLiteral(resourceName: "outside-page.png"),#imageLiteral(resourceName: "outside-page.png"),#imageLiteral(resourceName: "bookmark-outline.png"),#imageLiteral(resourceName: "outside-page.png")]
    var loaded: Int = 0
    let url: [URL] = [URL(string: "https://www.businessinsider.com/amazon-web-services-open-source-elasticsearch-2019-3")!,
                      URL(string: "https://www.businessinsider.com/zero-electric-motorcycle-brings-connectivity-race-for-e-bikes-2019-3")!,
                      URL(string: "https://www.businessinsider.com/lyft-ipo-public-s-1-filing-details-2019-2")!,
                      URL(string: "https://www.businessinsider.com/most-powerful-countries-ranked-us-news-and-world-report-2019-2")!,
                      URL(string: "https://www.businessinsider.com/highest-paying-job-in-every-us-state-2019-2")!,
                      URL(string: "https://www.businessinsider.com/theresa-may-defeated-on-eu-brexit-deal-meaningful-vote-for-second-time-2019-3")!]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func parseHTML(index: Int, completionHandler: @escaping (String) -> Void){
        Alamofire.request(url[index]).responseString { response in
            if let html: String = response.result.value {
                //NSLog(html)
                completionHandler(html)
            }
        }
    }
}

extension ArticleListScreen: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DispatchQueue.main.async() {
            tableView.reloadData()
        }
        return url.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") as! ArticleCell
        if(indexPath.row == 0){
            tableView.rowHeight = 90
            tableView.separatorStyle = .singleLine
            //cell.titleLabel.addConstraint(NSLayoutConstraint(item: cell.titleLabel, attribute: .bottom, relatedBy: .equal, toItem: cell, attribute: .bottom, multiplier: 1, constant: 0))
        }
        else if (indexPath.row == 1){
            tableView.rowHeight = 90
        }
        else{
            tableView.rowHeight = 90
        }
        if loaded < url.count {
            loaded += 1
            parseHTML(index: indexPath.row) { result in
                var attribute: String = ""
                do{
                    let doc: Document = try SwiftSoup.parse(result)
                    try attribute = doc.getElementsByClass("post-headline ").text()
                    NSLog("NEW SHIT: "+attribute)
                }catch{
                    NSLog("None")
                }
                self.titles[indexPath.row] = attribute
            cell.titleLabel.text = self.titles[indexPath.row]
                do{
                    let doc: Document = try SwiftSoup.parse(result)
                    try attribute = doc.getElementsByTag("img").attr("src")
                    NSLog(attribute)
                }catch{
                    NSLog("None")
                }
                self.getData(from: URL.init(string: attribute)!) { data, response, error  in
                    cell.thumbnail.contentMode = .scaleAspectFit
                    cell.thumbnail.image = UIImage(data: data!)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ArticleViewController") as? ArticleViewController
        vc?.url = url[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

