//
//  Frame.swift
//  Pelican
//
//  Created by Preston Willis on 3/10/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

import UIKit

class Frame: UIView {
    
    override func awakeFromNib() {
        drawSquare()
    }
    
    func drawSquare() {
        let square = self
        square.center = CGPoint(x: UIScreen.main.fixedCoordinateSpace.bounds.width/2, y: UIScreen.main.fixedCoordinateSpace.bounds.height)
        square.bounds.size = CGSize(width: UIScreen.main.fixedCoordinateSpace.bounds.width, height: UIScreen.main.fixedCoordinateSpace.bounds.height*3/2)
        square.backgroundColor = .white
        square.clipsToBounds = true
        square.layer.cornerRadius = 20
    }

}
