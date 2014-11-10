//
//  NotificationTableView.swift
//  HiNote
//
//  Created by cameron on 10/30/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation

import UIKit

class NotifcationController:  UITableViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate  {
    
    var stream: Stream = Stream()
    var searchResults: [Notification] = []
    //var message: [String] = ["Building Collapse in Towson", "JHU to lay off 2000 employees", "New Bar to open in Remington"]
    //var times: [String] = ["Today, 8:50pm near Towson, MD", "Today, 5:00pm near Baltimore, MD", "Today, 4:49pm near Baltimore, MD"]
    
    var SUBJECT = "#LocalNews"
    
    func settings() {
        let vc : AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("Settings")
        //self.presentViewController(vc as UITableViewController, animated: false, completion: nil)
        self.navigationController?.pushViewController(vc as UITableViewController, animated: true)
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.searchResults = (self.stream.Notifications).filter({( notification: Notification) -> Bool in
            let stringMatch = notification.title.rangeOfString(searchText)
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let rightSideButton: UIBarButtonItem = UIBarButtonItem(title:"Settings", style: .Plain, target: self, action: "settings")
        stream.addNotifications([Notification(title: "First", subtitle: "first Note"), Notification(title: "Second", subtitle: "second Note")])
        SUBJECT = stream.title
        self.navigationItem.rightBarButtonItem = rightSideButton
        self.searchDisplayController?.displaysSearchBarInNavigationBar = true
        getJson()
        //self.tableView.tableHeaderView = UIView( frame: CGRectMake( 0, 0, self.view.frame.width, 20 ) )
        
        //self.tableView.
        
       // (tableView: UITableView, UIEdgeInsetsMake(20, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right))
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getJson () {
        let url = NSURL(string: "http://mlbvsnba.no-ip.org/oose/sample_notification.json")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()
    }
    
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
       return self.SUBJECT
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "CellSubtitle")
        if  tableView == self.searchDisplayController!.searchResultsTableView {
            cell.textLabel.text = searchResults[indexPath.row].title
            cell.detailTextLabel?.text = searchResults[indexPath.row].subtitle
            return cell
        }
        cell.textLabel.text = self.stream.Notifications[indexPath.row].title
        cell.detailTextLabel?.text = self.stream.Notifications[indexPath.row].subtitle
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if  tableView == self.searchDisplayController!.searchResultsTableView {
            return self.searchResults.count
        }
        return stream.Notifications.count
    }
    
    func getNotificationsFromServer()
    {
        //get the notications from the server. For now hard-coded.
    }

}