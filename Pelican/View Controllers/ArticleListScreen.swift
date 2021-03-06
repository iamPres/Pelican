//
//  ArticleListScreen.swift
//  Pelican
//
//  Created by Preston Willis on 3/9/19.
//  Copyright © 2019 Preston Willis. All rights reserved.
//

/*
 ArticleListViewController lists article previews. It also loads the corresponding view upon
 cell selection and passes data to ArticleViewContoller
 */

import UIKit
import SwiftSoup
import Alamofire

class ArticleListScreen: UIViewController {
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var header: UIView!
    
    let notification = UINotificationFeedbackGenerator()
    let selection = UISelectionFeedbackGenerator()
    let impact = UIImpactFeedbackGenerator(style: .heavy)
    let Nightmode_class = Nightmode()
    
    var index: Int = 0 // Index of selected cell to pass into ArticleViewController
    var titles: [String] = [] // Article titles
    var images: [UIImage] = [] // Article thumbnails
    var loaded: Int = 0
    var lastContentOffset: CGFloat = 0 // Set a variable to hold the contentOffSet before scroll view scrolls
    
    var isReady: Bool = true
    
    @IBAction func menuSender(_ sender: UIButton) {
        if UserDefaults.standard.object(forKey: "didClickHeadline") as! Bool != true {
            UserDefaults.standard.set(true, forKey: "didClickHeadline")
            performSegue(withIdentifier: "menu", sender: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                UserDefaults.standard.set(false, forKey: "didClickHeadline")
            }
        }
    }
    
    // URLS to scrape
    let url: [URL] = [URL(string: "http://pelicanonline.sps.edu/index.php/2019/02/21/classic-society-competition/")!,
                      URL(string: "http://pelicanonline.sps.edu/index.php/2019/02/21/dancing-through-the-cold/")!,
                      URL(string: "http://pelicanonline.sps.edu/index.php/2019/02/11/swim-meet/")!,
                      URL(string: "http://pelicanonline.sps.edu/index.php/2019/02/11/the-carillonneurs-guild/")!,
                      URL(string: "http://pelicanonline.sps.edu/index.php/2019/02/07/chinese-new-year/")!,
                      URL(string: "http://pelicanonline.sps.edu/index.php/2019/02/07/joy/")!]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setErrorView()
        setNightView()
        setConstraints()
    }
    
    // Set ArticleViewController attributes before loading view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        impact.impactOccurred()
        if segue.destination.title == "ArticleViewController" {
            let vc = segue.destination as! ArticleViewController
            vc.url = url[index]
            vc.count = index
        }
    }
        
    func setNightView() {
        // Nightmode settings
        if Nightmode_class.changeColor(target: self, labels: [label,errorLabel]) {
            self.view.viewWithTag(2)?.backgroundColor = Nightmode_class.darkBackground
            menuButton.setImage(#imageLiteral(resourceName: "menu-button-of-three-horizontal-lines-white.png"), for: UIControl.State.normal)
        }
        else {
            self.view.viewWithTag(2)?.backgroundColor = Nightmode_class.lightColor
            menuButton.setImage(#imageLiteral(resourceName: "menu-button-of-three-horizontal-lines.png"), for: UIControl.State.normal)
        }
    }
    
    func setErrorView(){
        //Constraints
        self.errorLabel.addConstraint(NSLayoutConstraint(item: self.errorLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:UIScreen.main.fixedCoordinateSpace.bounds.width-200))
        
        //Error Label
        errorLabel.text = ""
        errorImage.image = #imageLiteral(resourceName: "output-onlinepngtools.png")
        
        if (UserDefaults.standard.object(forKey: "timedout") as! Bool){
            errorImage.image = #imageLiteral(resourceName: "white-buttons-png-8.png")
            errorLabel.text = "Unable to locate this rescource."
        }
    }
    
    func setConstraints(){
        if UIScreen.main.fixedCoordinateSpace.bounds.height == 667 || UIScreen.main.fixedCoordinateSpace.bounds.height == 736{
            self.header.addConstraint(NSLayoutConstraint(item: self.header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:50))
        }
        else {
            self.header.addConstraint(NSLayoutConstraint(item: self.header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:UIScreen.main.fixedCoordinateSpace.bounds.height*1/10))
        }
    }
    
    func loadHeadlineCellAttributes(cell: HeadlineCell, tableView: UITableView) -> HeadlineCell{
    
        tableView.separatorStyle = .singleLine
        tableView.isHidden = false
        
        // Nightmode settings
        if Nightmode_class.changeColor(target: self, labels: []) {
            cell.backgroundColor = Nightmode_class.darkBackground
            tableView.separatorColor = Nightmode_class.darkSeparator
        }
        else {
            cell.backgroundColor = Nightmode_class.lightColor
            tableView.separatorColor = Nightmode_class.lightSeparator
        }
        
        // Load corresponding cell attributes from storage as set in LoadingScreen
        //cell.thumbnail.contentMode = .scaleAspectFill
        let image = UIImage(data: (UserDefaults.standard.array(forKey: "images")![0] as! NSData) as Data)
        let imageWidth = image!.size.width
        let imageHeight = image!.size.height
        
        cell.thumbnail.image = image
        cell.thumbnail.addConstraint(NSLayoutConstraint(item: cell.thumbnail, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width-16))
        
        cell.thumbnail.addConstraint(NSLayoutConstraint(item: cell.thumbnail, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (UIScreen.main.bounds.width-16) * imageHeight / imageWidth))
        
        tableView.rowHeight = (UIScreen.main.bounds.width-16) * imageHeight / imageWidth
        
        return cell
    }
    
    func loadHeadlineTextCellAttributes(cell: HeadlineTextCell, tableView: UITableView) -> HeadlineTextCell{
        
        tableView.separatorStyle = .singleLine
        tableView.isHidden = false
        
        // Nightmode settings
        if Nightmode_class.changeColor(target: self, labels: [cell.headlineTextLabel]) {
            cell.backgroundColor = Nightmode_class.darkBackground
            tableView.separatorColor = Nightmode_class.darkSeparator
        }
        else {
            cell.backgroundColor = Nightmode_class.lightColor
            tableView.separatorColor = Nightmode_class.lightSeparator
        }
        
        cell.headlineTextLabel.text = UserDefaults.standard.array(forKey: "titles")![0] as? String
        
        cell.headlineTextLabel.sizeToFit()
        tableView.rowHeight = cell.headlineTextLabel.frame.size.height + 28
        
        return cell
        
    }
    
    func loadArticleCellAttributes(cell: ArticleCell, tableView: UITableView, index: Int) -> ArticleCell {
        
        // Set table attributes
        tableView.rowHeight = 90
        tableView.separatorStyle = .singleLine
        tableView.isHidden = false
        
        // Nightmode settings
        if Nightmode_class.changeColor(target: self, labels: [cell.titleLabel]) {
            cell.backgroundColor = Nightmode_class.darkBackground
            tableView.separatorColor = Nightmode_class.darkSeparator
        }
        else {
            cell.backgroundColor = Nightmode_class.lightColor
            tableView.separatorColor = Nightmode_class.lightSeparator
        }
        
        // Load corresponding cell attributes from storage as set in LoadingScreen
        cell.thumbnail.contentMode = .scaleAspectFit
        cell.thumbnail.image = UIImage(data: (UserDefaults.standard.array(forKey: "images")![index] as! NSData) as Data)
        cell.titleLabel.text = UserDefaults.standard.array(forKey: "titles")![index] as? String
        
        return cell
    }
    
    // Download image data
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // Download article contents
    func parseHTML(index: Int, completionHandler: @escaping (String) -> Void){
        Alamofire.request(url[index]).responseString { response in
            if let html: String = response.result.value {
                completionHandler(html)
            }
        }
    }
}

// UITableView Init.
extension ArticleListScreen: UITableViewDataSource, UITableViewDelegate {
    
    // Set number of rows to generate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return url.count + 1
    }
    
    // Set ArticleCell attributes for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        // Init. new cell
        let articleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") as? ArticleCell
        let headlineCell = tableView.dequeueReusableCell(withIdentifier: "HeadlineCell") as? HeadlineCell
        let headlineTextCell = tableView.dequeueReusableCell(withIdentifier: "HeadlineTextCell") as? HeadlineTextCell
            
            if UserDefaults.standard.object(forKey: "timedout") as! Bool {
                tableView.isHidden = true
            }
            else {
                if indexPath.row == 0 {
                    return loadHeadlineCellAttributes(cell: headlineCell!, tableView: tableView)
                } else if indexPath.row == 1{
                    return loadHeadlineTextCellAttributes(cell: headlineTextCell!, tableView: tableView)
                }else {
                    return loadArticleCellAttributes(cell: articleCell!, tableView: tableView, index: indexPath.row-1)
                }
            }
        return articleCell!
    }
    
    // Handle row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 || indexPath.row == 0 {
            index = 0
        } else {
            index = indexPath.row - 1
        }
        
        // prepare() and load view (Segue can only run once        
        if UserDefaults.standard.object(forKey: "didClickHeadline") as! Bool != true {
            UserDefaults.standard.set(true, forKey: "didClickHeadline")
            self.performSegue(withIdentifier: "segue2", sender: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                UserDefaults.standard.set(false, forKey: "didClickHeadline")
            }
        }
    }
    
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < -75 && self.lastContentOffset > scrollView.contentOffset.y && scrollView.scrollsToTop && scrollView.isDecelerating && self.isReady) {
            if UserDefaults.standard.object(forKey: "didClickHeadline") as! Bool != true {
                UserDefaults.standard.set(true, forKey: "didClickHeadline")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    UserDefaults.standard.set(false, forKey: "didClickHeadline")
                }
                notification.notificationOccurred(.error)
                self.performSegue(withIdentifier: "load", sender: nil)
                self.isReady = false
            }
        }
    }
}

