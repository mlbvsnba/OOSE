//
//  StreamTableView.swift
//  HiNote
//
//  Created by cameron on 10/30/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit

class StreamController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate  {
    var active: [Stream] = []
    var muted: [Stream] = []
    var newStreams: [Stream] = []
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchResults: [Stream] = []
    var con: UISearchDisplayController = UISearchDisplayController()
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if  tableView == self.searchDisplayController!.searchResultsTableView {
            cell.textLabel.text = searchResults[indexPath.row].title
            return cell
        }
        
        
        if indexPath.section == 0 {
        cell.textLabel.text = active[indexPath.row].title
        }
        if indexPath.section == 1 {
            cell.textLabel.text = muted[indexPath.row].title
        }
        if indexPath.section == 2 {
                cell.textLabel.text = newStreams[indexPath.row].title
        }

        return cell
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.searchResults = (self.active + self.muted + self.newStreams).filter({( stream: Stream) -> Bool in
            let stringMatch = stream.title.rangeOfString(searchText)
            return (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  tableView == self.searchDisplayController!.searchResultsTableView {
            return self.searchResults.count
        }
        if section == 0 {
            return active.count
        }
        if section == 1 {
            return muted.count
            }
        if section == 2 {
            return newStreams.count
            }
        return 0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if  tableView == self.searchDisplayController!.searchResultsTableView {
            return 1
        }
        return 3
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if  tableView == self.searchDisplayController!.searchResultsTableView {
            return "found"
        }
    if section == 0 {
        return "Active"
        }
    if section == 1 {
            return "Muted"
        }
        return "New"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc : NotifcationController! = self.storyboard?.instantiateViewControllerWithIdentifier("Notifications") as NotifcationController
        //self.presentViewController(vc as UITableViewController, animated: false, completion: nil)
        vc.stream = active[indexPath.row]
        self.navigationController?.pushViewController(vc as UITableViewController, animated: true)
    }

    func addStream() {
        println("add")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.active = [Stream(title: "Water"), Stream(title: "Fire"), Stream(title: "Air"), Stream(title: "Blue Sky")]
        self.muted = [Stream(title: "Breaking Bad"), Stream(title: "Shows You Don't Even Like"),Stream(title: "Funny") ]
        self.newStreams = [Stream(title: "WompWompWomp"), Stream(title: "CatDog"), Stream(title: "The Rains in Africa")]

        self.searchDisplayController?.displaysSearchBarInNavigationBar = true
        
        
        let rightSideButton: UIBarButtonItem = UIBarButtonItem(title:"Add", style: .Plain, target: self, action: "addStream")
        self.navigationItem.rightBarButtonItem = rightSideButton

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}