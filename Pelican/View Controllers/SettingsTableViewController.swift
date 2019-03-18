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
    
    let darkColor = UIColor.darkText
    let darkBackground = UIColor(red: 0.1,green: 0.0,blue: 0.1,alpha: 1.0)
    let lightColor = UIColor.white
    
    @IBAction func nightmode(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "nightmode")
        changeColor(target: self, labels: [pelicanLabel, nightModeLabel])
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
        nightmode_outlet.setOn(UserDefaults.standard.object(forKey: "nightmode") as! Bool, animated: true)
        
        if changeColor(target: self, labels: [pelicanLabel, nightModeLabel]){
            cell.backgroundColor = darkBackground
        }
        else {
            cell.backgroundColor = lightColor        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
