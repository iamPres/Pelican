//
//  PreviousIssue.swift
//  Pelican
//
//  Created by Preston Willis on 3/13/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//


// ---------------- COMING SOON ---------------- //

import UIKit

class PreviousIssue: UIViewController {
    @IBOutlet weak var pelican: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nightmode settings
        SettingsTableViewController().changeColor(target: self, labels: [pelican])
    }
}
