//
//  Nightmode.swift
//  Pelican
//
//  Created by Preston Willis on 3/24/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

import Foundation
import UIKit

class Nightmode {
    
    // Color palette for nightmode
    public let darkColor = UIColor.darkText
    public let darkBackground = UIColor(red: 0.1,green: 0.0,blue: 0.1,alpha: 1.0)
    public let lightColor = UIColor.white
    public let darkSeparator = UIColor.darkGray
    public let lightSeparator = UIColor.lightGray
    
    // Set view attributes for nightmode
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
            target.view.backgroundColor = lightColor
            for i in target.view.subviews {
                if i.isOpaque == true {
                    i.backgroundColor = lightColor
                }
            }
        }
        
        // Return nightmode state for further handling
        return UserDefaults.standard.object(forKey: "nightmode") as! Bool
    }
}
