//
//  SettingsTableViewController.swift
//  Pelican
//
//  Created by Preston Willis on 3/14/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

/*
 SettingsTableViewController records and saves settings data to sotrage
 */

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var pelicanLabel: UILabel!
    @IBOutlet weak var nightModeLabel: UILabel!
    @IBOutlet weak var nightmode_outlet: UISwitch!
    @IBOutlet weak var cell: UITableViewCell!
    @IBOutlet weak var pushnotifications: UILabel!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var notificationsCell: UITableViewCell!
    @IBOutlet weak var header: UIView!
    let impact = UIImpactFeedbackGenerator(style: .heavy)
    let Nightmode_class = Nightmode()
    
    // Handle push notifications state
    @IBAction func notifyme(_ sender: UISwitch) {
        impact.impactOccurred()
        UserDefaults.standard.set(sender.isOn, forKey: "notifyme")
    }
    
    // Handle nightmode state
    @IBAction func nightmode(_ sender: UISwitch) {
        impact.impactOccurred()
        
        // Save nightmode state to storage
        UserDefaults.standard.set(sender.isOn, forKey: "nightmode")
        
        // Nightmode settings
        nightmodeSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setConstraints()
        nightmodeSettings()
        setSwitchState()
    }
    
    func setSwitchState() {
        // Set switches according to saved state
        if (UserDefaults.standard.object(forKey: "nightmode") != nil) {
            nightmode_outlet.setOn(UserDefaults.standard.object(forKey: "nightmode") as! Bool, animated: true)
        }
        if (UserDefaults.standard.object(forKey: "notifyme") != nil) {
            notificationsSwitch.setOn(UserDefaults.standard.object(forKey: "notifyme") as! Bool, animated: true)
        }
    }
    
    func setConstraints(){
        if UIScreen.main.fixedCoordinateSpace.bounds.height == 667 || UIScreen.main.fixedCoordinateSpace.bounds.height == 736{
            self.header.addConstraint(NSLayoutConstraint(item: self.header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:50))
        }
        else {
            self.header.addConstraint(NSLayoutConstraint(item: self.header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:UIScreen.main.fixedCoordinateSpace.bounds.height*1/10))
        }
    }
    
    func nightmodeSettings() {
        // Nightmode settings
        if Nightmode_class.changeColor(target: self, labels: [pelicanLabel, nightModeLabel, pushnotifications]) {
            cell.backgroundColor = Nightmode_class.darkBackground
            notificationsCell.backgroundColor = Nightmode_class.darkBackground
            self.tableView.separatorColor = Nightmode_class.darkSeparator
        }
        else {
            cell.backgroundColor = Nightmode_class.lightColor
            notificationsCell.backgroundColor = Nightmode_class.lightColor
            self.tableView.separatorColor = Nightmode_class.lightSeparator
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
