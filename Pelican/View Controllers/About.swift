//
//  About.swift
//  Pelican
//
//  Created by Preston Willis on 3/13/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

import UIKit

class About: UIViewController {
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var authorname: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var inquiries: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var pelican: UILabel!
    @IBOutlet weak var dateofpublication: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nightmode settings
        SettingsTableViewController().changeColor(target: self, labels: [author,authorname,dateofpublication,date,inquiries,email,pelican])
 
    }
}
