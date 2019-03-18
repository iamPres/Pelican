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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsTableViewController().changeColor(target: self, labels: [pelican])
    }
}
