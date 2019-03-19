//
//  SettingsTableViewController.swift
//  Pelican
//
//  Created by Preston Willis on 3/14/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var pelicanLabel: UILabel!
    @IBOutlet weak var nightModeLabel: UILabel!
    @IBOutlet weak var nightmode_outlet: UISwitch!
    @IBOutlet weak var cell: UITableViewCell!
    @IBOutlet weak var pushnotifications: UILabel!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var notificationsCell: UITableViewCell!
    
    let darkColor = UIColor.darkText
    let darkBackground = UIColor(red: 0.1,green: 0.0,blue: 0.1,alpha: 1.0)
    let lightColor = UIColor.white
    
    @IBAction func notifyme(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "notifyme")
    }
    
    @IBAction func nightmode(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "nightmode")
        changeColor(target: self, labels: [pelicanLabel, nightModeLabel, pushnotifications])
    }
    
    public func changeColor(target: UIViewController, labels: [UILabel]) -> Bool {
        if UserDefaults.standard.object(forKey: "nightmode") as? Bool == true {
            target.view.backgroundColor = darkBackground
            for label in labels {
                label.textColor = lightColor
                label.textColor = lightColor
            }
            for i in target.view.subviews {
                if i.isOpaque == true {
                i.backgroundColor = darkBackground
                }
            }
        }
        else {
            for label in labels {
                label.textColor = darkColor
                label.textColor = darkColor
            }
            self.view.backgroundColor = lightColor
            for i in target.view.subviews {
                if i.isOpaque == true {
                i.backgroundColor = lightColor
                }
            }
        }
        return UserDefaults.standard.object(forKey: "nightmode") as! Bool
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (UserDefaults.standard.object(forKey: "nightmode") != nil) {
            nightmode_outlet.setOn(UserDefaults.standard.object(forKey: "nightmode") as! Bool, animated: true)
        }
        if (UserDefaults.standard.object(forKey: "notifyme") != nil) {
            notificationsSwitch.setOn(UserDefaults.standard.object(forKey: "notifyme") as! Bool, animated: true)
        }
        
        if changeColor(target: self, labels: [pelicanLabel, nightModeLabel, pushnotifications]){
            cell.backgroundColor = darkBackground
            notificationsCell.backgroundColor = darkBackground
            self.tableView.separatorColor = UIColor.darkGray
        }
        else {
            cell.backgroundColor = lightColor
            notificationsCell.backgroundColor = lightColor
            self.tableView.separatorColor = UIColor.lightGray
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
}
