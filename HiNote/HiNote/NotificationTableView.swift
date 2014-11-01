//
//  NotificationTableView.swift
//  HiNote
//
//  Created by cameron on 10/30/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation

import UIKit

class NotifcationController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var message: [String] = ["Building Collapse in Towson", "JHU to lay off 2000 employees", "New Bar to open in Remington"]
    var times: [String] = ["Today, 8:50pm near Towson, MD", "Today, 5:00pm near Baltimore, MD", "Today, 4:49pm near Baltimore, MD"]
    
    var SUBJECT = "#LocalNews"
    
    func settings() {
        let vc : AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("Settings")
        //self.presentViewController(vc as UITableViewController, animated: false, completion: nil)
        self.navigationController?.pushViewController(vc as UITableViewController, animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let rightSideButton: UIBarButtonItem = UIBarButtonItem(title:"Settings", style: .Plain, target: self, action: "settings")
        self.navigationItem.rightBarButtonItem = rightSideButton
        
        getJson()
        self.tableView.tableHeaderView = UIView( frame: CGRectMake( 0, 0, self.view.frame.width, 20 ) )
        
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
        cell.textLabel.text = self.message[ (indexPath.row) % self.message.count ]
        cell.detailTextLabel?.text = self.times[ (indexPath.row) % self.message.count ]
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    
    func getNotificationsFromServer()
    {
        //get the notications from the server. For now hard-coded.
    }

}