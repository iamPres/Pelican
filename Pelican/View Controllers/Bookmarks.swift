//
//  Bookmarks.swift
//  Pelican
//
//  Created by Preston Willis on 3/13/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

/*
 Bookmarks loads bookmarked data from storage and displays saved articles. It also
 handles row selection and loads ArticleViewController with corresponding index
 */

import UIKit

class Bookmarks: UIViewController {
    @IBOutlet weak var pelican: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    
    var index: Int = 0 // Index of bookmarked article to load in ArticleViewController
    var count: Int = 0 // Number of bookmarked articles
    var indexes: [Int] = [] // Storage indexes of bookmarked articles
    
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set constraints
        self.message.addConstraint(NSLayoutConstraint(item: self.message, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:UIScreen.main.fixedCoordinateSpace.bounds.width-200))
        
        // Nightmode settings
        if SettingsTableViewController().changeColor(target: self, labels: [pelican, message]) {
            image = #imageLiteral(resourceName: "bookmark-outline-white.png")
        }
        else {
            image = #imageLiteral(resourceName: "bookmark-outline.png")
        }
        
        // Iterate through saved bookmarks and log indexes
        for i in 0..<(UserDefaults.standard.array(forKey: "bookmarkArray")!.count) {
            if UserDefaults.standard.array(forKey: "bookmarkArray")![i] as? Bool == true {
                indexes.append(i)
                
                // Calculate number of saved articles for cell generation
                count += 1
            }
        }
    }
    
    // Pass index of article data to ArticleViewController to be loaded
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.title == "ArticleViewController" {
            let vc = segue.destination as! ArticleViewController
            vc.count = index
        }
    }
}

// Init. UITableView
extension Bookmarks: UITableViewDataSource, UITableViewDelegate {
    
    // Set number of cells to generate based on number of bookmarked articles
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If no bookmarked articles, make table invisible and add informative message
        if count == 0
        {
            messageImage.image = image
            message.text = "Nothing to see here."
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
        cell.thumbnail.contentMode = .scaleAspectFit
        cell.thumbnail.image = UIImage(data: UserDefaults.standard.data(forKey: "image"+String(indexes[indexPath.row]))!)
        let attributes: [String] = UserDefaults.standard.array(forKey: "html"+String(indexes[indexPath.row])) as! [String]
        cell.titleLabel.text = attributes[0]
        
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
        index = indexes[indexPath.row]
        
        // prepare() and load view
        self.performSegue(withIdentifier: "segue3", sender: nil)
    }
}


