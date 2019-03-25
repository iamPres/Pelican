//
//  PreviousIssue.swift
//  Pelican
//
//  Created by Preston Willis on 3/13/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//


// ---------------- COMING SOON ---------------- //

import UIKit

class PreviousIssue: UIViewController {
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var pelican: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var header: UIView!
    var image: UIImage? = nil
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Constraints
        setConstraints()
        
        // Nightmode settings
        if SettingsTableViewController().changeColor(target: self, labels: [pelican, message]) {
            image = #imageLiteral(resourceName: "newspaper-white.png")
        }
        else {
            image = #imageLiteral(resourceName: "newspaper.png")
        }
    }
    
    func setConstraints(){
        
        self.message.addConstraint(NSLayoutConstraint(item: self.message, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:UIScreen.main.fixedCoordinateSpace.bounds.width-200))
        
        if UIScreen.main.fixedCoordinateSpace.bounds.height == 667 || UIScreen.main.fixedCoordinateSpace.bounds.height == 736{
            self.header.addConstraint(NSLayoutConstraint(item: self.header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:50))
        }
        else {
            self.header.addConstraint(NSLayoutConstraint(item: self.header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:UIScreen.main.fixedCoordinateSpace.bounds.height*1/10))
        }
    }
}

// Init. UITableView
extension PreviousIssue: UITableViewDataSource, UITableViewDelegate {
    
    // Set number of cells to generate based on number of bookmarked articles
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If no bookmarked articles, make table invisible and add informative message
        messageImage.image = #imageLiteral(resourceName: "output-onlinepngtools.png")
        if count == 0
        {
            messageImage.image = image
            message.text = "Coming soon."
            tableView.separatorStyle = .none
        }
        else {
            message.text = ""
        }
        
        return count
    }
    
    // Generate UITableView cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Generate cell using ArticleCell template
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") as! ArticleCell
        
        // Load cell attributes from bookmarked storage index
        tableView.rowHeight = 90
        //cell.thumbnail.contentMode = .scaleAspectFit
        //cell.thumbnail.image = UIImage(data: UserDefaults.standard.data(forKey: "image"+String(indexes[indexPath.row]))!)
        //let attributes: [String] = UserDefaults.standard.array(forKey: "html"+String(indexes[indexPath.row])) as! [String]
       // cell.titleLabel.text = attributes[0]
        
        // Nightmode settings
        if SettingsTableViewController().changeColor(target: self, labels: [cell.titleLabel]) {
            cell.backgroundColor = SettingsTableViewController().darkBackground
            tableView.separatorColor = UIColor.darkGray
        }
        else {
            cell.backgroundColor = SettingsTableViewController().lightColor
            tableView.separatorColor = UIColor.lightGray
        }
        return cell
    }
    
    // Handle row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("SELECTED: "+String(indexPath.row))
        
        // set index to pass into ArticleViewController
        //index = indexes[indexPath.row]
        
        // prepare() and load view
        //self.performSegue(withIdentifier: "segue3", sender: nil)
    }
}


