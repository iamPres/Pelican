//
//  Bookmarks.swift
//  Pelican
//
//  Created by Preston Willis on 3/13/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

import UIKit

class Bookmarks: UIViewController {
    @IBOutlet weak var pelican: UILabel!
    var index: Int = 0
    var count: Int = 0
    var indexes: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsTableViewController().changeColor(target: self, labels: [pelican])
        for i in 0..<(UserDefaults.standard.array(forKey: "bookmarkArray")!.count) {
            if UserDefaults.standard.array(forKey: "bookmarkArray")![i] as? Bool == true {
                indexes.append(i)
                count += 1
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.title == "ArticleViewController" {
            let vc = segue.destination as! ArticleViewController
            vc.count = index
        }
    }
}

extension Bookmarks: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if count == 0
        {
            tableView.separatorStyle = .none
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") as! ArticleCell
        tableView.rowHeight = 90
        cell.thumbnail.contentMode = .scaleAspectFit
        cell.thumbnail.image = UIImage(data: UserDefaults.standard.data(forKey: "image"+String(indexes[indexPath.row]))!)
        let attributes: [String] = UserDefaults.standard.array(forKey: "html"+String(indexes[indexPath.row])) as! [String]
        cell.titleLabel.text = attributes[0]
        
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
        index = indexes[indexPath.row]
        self.performSegue(withIdentifier: "segue3", sender: nil)
    }
}


