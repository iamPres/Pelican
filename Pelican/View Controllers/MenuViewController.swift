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
    let images: [UIImage] = [#imageLiteral(resourceName: "newspaper.png"),#imageLiteral(resourceName: "bookmark-outline.png"),#imageLiteral(resourceName: "settings.png"),#imageLiteral(resourceName: "outside-page.png"),#imageLiteral(resourceName: "info.png")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
        cell.imageView!.image = images[indexPath.row]
        cell.label.text = titles[indexPath.row]
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
