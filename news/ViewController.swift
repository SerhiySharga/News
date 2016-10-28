//
//  ViewController.swift
//  news
//
//  Created by Afionas on 10/27/16.
//  Copyright © 2016 SerhiySharga. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {

    enum Constants {
        static let showDetailsInfoIndentifier = "showDetailsInfoIndentifier"
    }
    
    var activeItem: ItemsBase? = nil
    let pbLoadURL = "https://newsapi.org/v1/sources?language=en"
    var sourcess = [ItemsBase]()
    
    let searchBar = UISearchBar()
    var filteredItems = [ItemsBase]()
    var shouldShowSearchResoults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
        getItemsList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResoults {
            return filteredItems.count
        }
        else {
            return sourcess.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        
        if shouldShowSearchResoults {
            cell.categoryLabel?.text = filteredItems[indexPath.row].category
                return cell
        }
        else {
        cell.nameLabel?.text = sourcess[indexPath.row].name
        cell.categoryLabel?.text = sourcess[indexPath.row].category
        
        return cell
        }
    }
    
    
    func getItemsList(){
        let request = NSURLRequest(URL: NSURL(string: pbLoadURL)!)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            
            
            if let error = error {
                
                print(error)
                return
            }
           //Parsing
            if let data = data {
                self.sourcess = self.parseJsonData(data)
                NSOperationQueue.mainQueue().addOperationWithBlock({() -> Void in
                    self.tableView.reloadData()
                })
            }
           })
        task.resume()
    }
     func parseJsonData(data: NSData) -> [ItemsBase] {
        
        do {
            let jsonResoult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            
            //Pars Json Data
            let jsonItems = jsonResoult!["sources"] as! [AnyObject!]
            for jsonItem in jsonItems {
                let item = ItemsBase()
                item.name = jsonItem["name"] as! String
                item.category = jsonItem["category"] as! String
               // item.image = jsonItem["image"] as! String
                sourcess.append(item)
            }
        } catch {
            print(error)
        }
        
        return sourcess
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        let itemLine = sourcess[indexPath.section]
        activeItem = sourcess[row]
        print(sourcess[row])
        performSegueWithIdentifier(Constants.showDetailsInfoIndentifier, sender: nil)
        
    }
    //MARK: Search Bar
    func createSearchBar(){
        
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Category"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResoults = true
        searchBar.endEditing(true)
        self.tableView.reloadData()
    }
    
    // Add search
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredItems = sourcess.filter({ (categor: ItemsBase) -> Bool in
         
            return categor.category.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
        
        })
        if searchText != "" {
            shouldShowSearchResoults = true
            self.tableView.reloadData()
        }
        else {
            shouldShowSearchResoults = false
            self.tableView.reloadData()
        }
        
    }
}

