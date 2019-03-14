//
//  ClickHeadline.swift
//  Pelican
//
//  Created by Preston Willis on 3/11/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

import UIKit

class ClickHeadline: UIStoryboardSegue {
    
    override func perform() {
        segue()
    }
    
    func segue() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        
        toViewController.view.transform = CGAffineTransform(translationX: 500, y: 0)
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, delay:0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }, completion: {
            success in fromViewController.present(toViewController, animated: false, completion: nil)
        })
    }

}
