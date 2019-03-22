//
//  MenuViewController.swift
//  Pelican
//
//  Created by Preston Willis on 3/11/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

/*
 MenuViewController constructs menu and loads corresponding views on cell selection
 */

import UIKit


class MenuViewController: UIViewController {
    let titles: [String] = ["Previous Issues", "Bookmarks", "Settings", "Website", "About"] // Cell titles
    var images: [UIImage] = [#imageLiteral(resourceName: "newspaper.png"),#imageLiteral(resourceName: "bookmark-outline.png"),#imageLiteral(resourceName: "settings.png"),#imageLiteral(resourceName: "outside-page.png"),#imageLiteral(resourceName: "info.png")] // Cell thumbnails
    let impact = UIImpactFeedbackGenerator(style: .heavy)
    
    @IBOutlet weak var pelican: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nightmode settings
        SettingsTableViewController().changeColor(target: self, labels: [pelican])
    }
    
    // Load new view and transition with animation
    func segue(index: Int){
        
        // Index new view by title
        let newViewController = storyboard!.instantiateViewController(withIdentifier: titles[index])
        let containerView = self.view.superview
        
        // Animate
        newViewController.view.transform = CGAffineTransform(translationX: 500, y: 0)
        containerView?.addSubview(newViewController.view)
        UIView.animate(withDuration: 0.5, delay:0, options: .curveEaseInOut, animations: {
            newViewController.view.transform = CGAffineTransform.identity
        }, completion: {
            success in self.present(newViewController, animated: false, completion: nil)
        })
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    // set number of rows to generate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    // Set cell attributes
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = 90
    
        if indexPath.row == 4 {
            tableView.separatorStyle = .none
        }
        else {
        tableView.separatorStyle = .singleLine
        }
        
        // Generate new cell as MenuCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        cell.label.text = titles[indexPath.row]
        
        // Nightmode settings
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
            tableView.separatorColor = UIColor.lightGray
        }
            cell.picture.image = images[indexPath.row]
            return cell
        }
    
    // Handle cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        impact.impactOccurred()
        
        // If fourth cell selected, load website
        if indexPath.row == 3{
            UIApplication.shared.openURL(NSURL(string: "http://millville.sps.edu")! as URL)
        }
        // Else, load new view by index
        else {
            segue(index: indexPath.row)
        }
    }
}

