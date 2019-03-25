//
//  MenuCell.swift
//  Pelican
//
//  Created by Preston Willis on 3/11/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
}
