//
//  CrossFade.swift
//  Pelican
//
//  Created by Preston Willis on 3/14/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

import UIKit

class CrossFade: UIStoryboardSegue {
    override func perform() {
        let source = self.source as UIViewController
        let destination = self.destination as UIViewController
        let window = UIApplication.shared.keyWindow!
            
        destination.view.alpha = 0.0
        window.insertSubview(destination.view, belowSubview: source.view)
            
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            source.view.alpha = 0.0
            destination.view.alpha = 1.0
        }) { (finished) -> Void in
            source.view.alpha = 1.0
            source.present(destination, animated: false, completion: nil)
        }
    }
}
