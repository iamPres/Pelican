//
//  MenuViewController.swift
//  Pelican
//
//  Created by Preston Willis on 3/11/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

import UIKit


class MenuViewController: UIViewController {
    let titles: [String] = ["Previous Issues", "Bookmarks", "Settings", "Website", "About"]
    var images: [UIImage] = [#imageLiteral(resourceName: "newspaper.png"),#imageLiteral(resourceName: "bookmark-outline.png"),#imageLiteral(resourceName: "settings.png"),#imageLiteral(resourceName: "outside-page.png"),#imageLiteral(resourceName: "info.png")]
    @IBOutlet weak var pelican: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        SettingsTableViewController().changeColor(target: self, labels: [pelican])
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 90
        tableView.separatorStyle = .singleLine
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        cell.label.text = titles[indexPath.row]
        if UserDefaults.standard.object(forKey: "nightmode") as! Bool{
            cell.backgroundColor = SettingsTableViewController().darkBackground
            cell.label.textColor = SettingsTableViewController().lightColor
            tableView.separatorColor = UIColor.darkGray
            images = [#imageLiteral(resourceName: "newspaper-white.png"),#imageLiteral(resourceName: "bookmark-outline-white.png"),#imageLiteral(resourceName: "settings-white.png"),#imageLiteral(resourceName: "outside-page-white.png"),#imageLiteral(resourceName: "info-white.png")]
        }
        else {
            cell.backgroundColor = SettingsTableViewController().lightColor
            cell.label.textColor = SettingsTableViewController().darkColor
            images = [#imageLiteral(resourceName: "newspaper.png"),#imageLiteral(resourceName: "bookmark-outline.png"),#imageLiteral(resourceName: "settings.png"),#imageLiteral(resourceName: "outside-page.png"),#imageLiteral(resourceName: "info.png")]
            tableView.separatorColor = UIColor.darkText
        }
            cell.imageView!.image = images[indexPath.row]
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3{
            UIApplication.shared.openURL(NSURL(string: "http://millville.sps.edu")! as URL)
        }
        else {
        let newViewController = storyboard!.instantiateViewController(withIdentifier: titles[indexPath.row])
        newViewController.navigationController?.setNavigationBarHidden(true, animated: true)
        self.present(newViewController, animated: true, completion: nil)
        }
    }
}

