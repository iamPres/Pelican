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
    @IBOutlet weak var header: UIView!
    
    let Nightmode_class = Nightmode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        
        // Nightmode settings
        Nightmode_class.changeColor(target: self, labels: [author,authorname,dateofpublication,date,inquiries,email,pelican])
 
    }
    
    func setConstraints(){
        if UIScreen.main.fixedCoordinateSpace.bounds.height == 667 || UIScreen.main.fixedCoordinateSpace.bounds.height == 736{
            self.header.addConstraint(NSLayoutConstraint(item: self.header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:50))
        }
        else {
            self.header.addConstraint(NSLayoutConstraint(item: self.header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:UIScreen.main.fixedCoordinateSpace.bounds.height*1/10))
        }
    }
}
