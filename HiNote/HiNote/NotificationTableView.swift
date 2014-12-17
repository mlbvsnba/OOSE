//
//  NotificationTableView.swift
//  HiNote
//
//  Created by cameron on 10/30/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation

import UIKit

// Controller for the notification tablewView
class NotifcationController:  UITableViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate  {
    
    var notificationStream: Stream = Stream()
    var notificationSearchResults: [NotificationInfo] = []

    let colors = ColorScheme()
    
    //default subject
    var SUBJECT = ""
    
    /*
    * When the settings button is clicked, this function is called
    */
    func settings() {
        let vc : AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("Settings")
        self.navigationController?.pushViewController(vc as UITableViewController, animated: true)
    }
    
    /* Filter function: filters tableview given a string
    * @param searchText: the text to filter on
    */
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.notificationSearchResults = (self.notificationStream.getNotifications()).filter({( notificationInfo: NotificationInfo) -> Bool in
            let stringMatch = notificationInfo.text.rangeOfString(searchText)
            return (stringMatch != nil)
        })
    }
    
    /*
    * Search controller delegate function, deals with he control of the search
    */
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    /*
    * Search controller delegate function, deals with he control of the search
    */
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    /*
    * When page is loaded, this function is called
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set the subject and the buttons and headers
        SUBJECT = notificationStream.getTitle()
        self.searchDisplayController?.displaysSearchBarInNavigationBar = true
        let rightSideButton: UIBarButtonItem = UIBarButtonItem(title:"Settings", style: .Plain, target: self, action: "settings")
        self.navigationItem.rightBarButtonItem = rightSideButton
        self.navigationItem.leftBarButtonItem?.title = "back"
        
        //Colors:
        self.view.backgroundColor = self.colors.getCellColor()
        self.navigationController?.navigationBar.tintColor = self.colors.getTextColor() // UIColor.blackColor()
        self.navigationController?.navigationBar.barTintColor = self.colors.getBackGroundColor() // self.backColor
    }

    /* Tableview delegate, return title for the header in a section
    */
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
       return self.SUBJECT
    }
    
    /* Tablew view delegate, returns the actual header object for each header in the tableview
    */
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        var header = tableViewHeader( headerFrame: CGRectMake(0, 0, tableView.bounds.size.width, 30), textFrame: CGRectMake(20, 5, tableView.bounds.size.width - 20 - 10, 15) )
        
        header.setText( self.SUBJECT )
        
        return header
    }
    
    /*
    * Tableview delegate: returns the cell at an index in the tableview
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //Create a new information object
        var currentCellDetails: NotificationInfo
        
        //Set the information objects variables
        if( tableView == self.searchDisplayController!.searchResultsTableView ) {
            currentCellDetails = self.notificationSearchResults[ indexPath.row ]
        } else {
            currentCellDetails = self.notificationStream.getNoticationAtIndex( indexPath.row )
        }
        
        //Create a new cell and connect the information to it.
        var cell = NotificationCell( style: .Subtitle, reuseIdentifier: "CellSubtitle", info: currentCellDetails )
        cell.accessoryType =  UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }
    
    /*
    * TableView delegate: get the number of rows in a section.
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if  tableView == self.searchDisplayController!.searchResultsTableView {
            return self.notificationSearchResults.count
        }
        
        return self.notificationStream.getNotificationCount()
    }
    
    /*
    * TableView delegate: when one clicks on a row in the tableview
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedNotificationInfo = self.notificationStream.getNoticationAtIndex( indexPath.row )
        
        UIApplication.sharedApplication().openURL( NSURL( string: selectedNotificationInfo.getUrl() )! )
    }
    
    /*
    * TableView delegate: edit the actions in a row (swipe left on row)
    */
    override func tableView( tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath ) -> [AnyObject]?
    {
        //Get alert window
        var addCategoryAlert = UIAlertController(title: "Send to Friend", message: "Please enter friend's name:", preferredStyle: UIAlertControllerStyle.Alert)
        
        //Add buttons and actions to it
        addCategoryAlert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default,
            handler: {(alertAction:UIAlertAction!) in
                let textField = addCategoryAlert.textFields![0] as UITextField
                self.sendToFriend(textField.text)} ))
        addCategoryAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        addCategoryAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter Name"
            textField.secureTextEntry = false
        })
        self.presentViewController(addCategoryAlert, animated: true, completion: nil)
        
        
        return nil
    }

    /*
    * When you send a notification to a friend, this function is called
    * @param friend: the id of the user to send it to
    */
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

}