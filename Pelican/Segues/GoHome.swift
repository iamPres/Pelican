//
//  GoHome.swift
//  Pelican
//
//  Created by Preston Willis on 3/11/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

 /*
 Backwards transition animation
 */

import UIKit

class GoHome: UIStoryboardSegue {
    
    override func perform() {
        segue()
    }
    
    func segue() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        
        // Move destination view 500 to the right and prepare view heirarchy
        toViewController.view.transform = CGAffineTransform(translationX: -500, y: 0)
        containerView?.addSubview(toViewController.view)
        
        // Animate
        UIView.animate(withDuration: 0.5, delay:0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }, completion: {
            success in fromViewController.present(toViewController, animated: false, completion: nil)
        })
    }
    
}

