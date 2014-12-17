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
    
    //var stream: Stream = Stream()
    var notificationStream: Stream = Stream()
    
    //var searchResults: [Notification] = []
    var notificationSearchResults: [NotificationInfo] = []

    let colors = ColorScheme()
    
    var SUBJECT = "#LocalNews"
    
    func settings() {
        let vc : AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("Settings")
        //self.presentViewController(vc as UITableViewController, animated: false, completion: nil)
        self.navigationController?.pushViewController(vc as UITableViewController, animated: true)
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.notificationSearchResults = (self.notificationStream.getNotifications()).filter({( notificationInfo: NotificationInfo) -> Bool in
            let stringMatch = notificationInfo.text.rangeOfString(searchText)
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
        //stream.addNotifications([Notification(title: "First", subtitle: "first Note"), Notification(title: "Second", subtitle: "second Note")])
        
        self.notificationStream.addNotifications([NotificationInfo(dev: "Matt", notificationText: "One", notificationUrl: "http://www.google.com",
            notificationTime: NSDate()), NotificationInfo(dev: "Cameron", notificationText: "It's ma biffday", notificationUrl: "http://www.google.com", notificationTime: NSDate())])
        
        SUBJECT = notificationStream.getTitle()
        self.searchDisplayController?.displaysSearchBarInNavigationBar = true
        let rightSideButton: UIBarButtonItem = UIBarButtonItem(title:"Settings", style: .Plain, target: self, action: "settings")
        self.navigationItem.rightBarButtonItem = rightSideButton
        self.navigationItem.leftBarButtonItem?.title = "back"
        
        //Colors:
        self.view.backgroundColor = self.colors.getCellColor()
        self.navigationController?.navigationBar.tintColor = self.colors.getTextColor() // UIColor.blackColor()
        self.navigationController?.navigationBar.barTintColor = self.colors.getBackGroundColor() // self.backColor
        //self.tableView.tableHeaderView = UIView( frame: CGRectMake( 0, 0, self.view.frame.width, 20 ) )
        
        //self.tableView.
        
       // (tableView: UITableView, UIEdgeInsetsMake(20, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right))
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
       return self.SUBJECT
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        var header = tableViewHeader( headerFrame: CGRectMake(0, 0, tableView.bounds.size.width, 30), textFrame: CGRectMake(20, 5, tableView.bounds.size.width - 20 - 10, 15) )
        
        header.setText( self.SUBJECT )
        
        return header
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //var cellText = self.stream.Notifications[indexPath.row].subtitle
        //var cellSubText = self.stream.Notifications[indexPath.row].subtitle
        
        //var currentCellDetails = NotificationInfo(dev: "Matt", notifactionText: cellText, notificationUrl: "www.google.com", notificationTime: NSDate())
        
        var currentCellDetails: NotificationInfo
        
        if( tableView == self.searchDisplayController!.searchResultsTableView ) {
            currentCellDetails = self.notificationSearchResults[ indexPath.row ]
        } else {
            currentCellDetails = self.notificationStream.getNoticationAtIndex( indexPath.row )
        }
        
        var cell = NotificationCell( style: .Subtitle, reuseIdentifier: "CellSubtitle", info: currentCellDetails )
        cell.accessoryType =  UITableViewCellAccessoryType.DisclosureIndicator
                /*
        var cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "CellSubtitle")
        cell.backgroundColor = self.cellColor
        
        if  tableView == self.searchDisplayController!.searchResultsTableView {
            cell.textLabel.text = searchResults[indexPath.row].title
            cell.detailTextLabel?.text = searchResults[indexPath.row].subtitle
            return cell
        }
        
        cell.textLabel.text = self.stream.Notifications[indexPath.row].title
        cell.detailTextLabel?.text = self.stream.Notifications[indexPath.row].subtitle
        return cell
        */
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if  tableView == self.searchDisplayController!.searchResultsTableView {
            return self.notificationSearchResults.count
        }
        
        return self.notificationStream.getNotificationCount()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedNotificationInfo = self.notificationStream.getNoticationAtIndex( indexPath.row )
        
        UIApplication.sharedApplication().openURL( NSURL( string: selectedNotificationInfo.getUrl() )! )
    }
    
    func sendToFriend(friend: String) {
        let url: String = Constants.baseUrl + "forward/"
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var err: NSError?
        
        var bodyData = "username=" + getUsername() + "&password=" +  getPasscode() + "&other_username=" + friend
        
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        //request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        //print(request.HTTPBody)
        var task = session.dataTaskWithRequest((request), completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                  print( "success")
                }
            }
        })
        task.resume()
    }

    func addStream() {
        
        var addCategoryAlert = UIAlertController(title: "Send to Friend", message: "Please enter the username to forward to:", preferredStyle: UIAlertControllerStyle.Alert)
        addCategoryAlert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default,
            handler: {(alertAction:UIAlertAction!) in
                let textField = addCategoryAlert.textFields![0] as UITextField
                self.sendToFriend(textField.text)} ))
        addCategoryAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        addCategoryAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter hashtag"
            textField.secureTextEntry = false
        })
        self.presentViewController(addCategoryAlert, animated: true, completion: nil)
        
    }
    

}