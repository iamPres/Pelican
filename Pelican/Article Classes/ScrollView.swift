//
//  ScrollView.swift
//  Pelican
//
//  Created by Preston Willis on 3/10/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

import UIKit

class ScrollView: UIScrollView {

    let square = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let myScrollView = self
        myScrollView.contentSize = CGSize(width: UIScreen.main.fixedCoordinateSpace.bounds.width, height: 3000)
    }
}
