//
//  StreamTableView.swift
//  HiNote
//
//  Created by cameron on 10/30/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit

class StreamController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, NSURLConnectionDelegate  {
    var active: [Stream] = []
    var muted: [Stream] = []
    var newStreams: [Stream] = []
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchResults: [Stream] = []
    var con: UISearchDisplayController = UISearchDisplayController()
    
    let colors = ColorScheme()

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: StreamCell
        
        if( tableView == self.searchDisplayController!.searchResultsTableView ) {
            cell = StreamCell( text: searchResults[ indexPath.row ].title )
            return cell
        }
        
        switch( indexPath.section )
        {
        case 0: cell = StreamCell( text: self.active[ indexPath.row ].title )
            break
        case 1: cell = StreamCell( text: self.muted[ indexPath.row ].title )
            break
        case 2: cell = StreamCell( text: self.newStreams[ indexPath.row ].title )
             break
        default: cell = StreamCell()
        }
        
        return cell
    }
    
    func getNotifications(id: String, stream: Stream) {
        let url: NSURL = NSURL(string: "http://localhost:8000/listnotif/?id=" + id)!
        let session = NSURLSession.sharedSession()
        println("made it")
        let task = session.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            var err: NSError?
            let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
            if let notificationArray = jsonObject as? NSArray{
                for notification in notificationArray {
                if let streamJSON = notification as? NSDictionary {
                    if let nextJSON = streamJSON["fields"] as? NSDictionary {
                        stream.addNotifications( [NotificationInfo(dev: "Matt", notificationText: nextJSON["contents"]as String!, notificationUrl: "http://www.google.com", notificationTime: NSDate() )])
                    }
                }
                } //dev: String, notificationText: String, notificationUrl: String,
                //notificationTime: NSDate
            }
    })
    task.resume()
    }
    
    func getStreams() {
        let url: NSURL = NSURL(string: "http://localhost:8000/listall/")!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            var err: NSError?
           let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
            if let streamArray = jsonObject as? NSArray{
                for stream  in streamArray  {
                    if let streamJSON = stream as? NSDictionary {
                        
                        if let nextJSON = streamJSON["fields"] as? NSDictionary {
                            let toAdd = Stream(title: nextJSON["description"]as String!)
                            self.active.append(toAdd)
                            if let id = streamJSON["pk"] as? Int {
                                self.getNotifications(String(id), stream: toAdd)
                            }
                        }
                    }
                }
            }
        })
        task.resume()
        while (task.state != NSURLSessionTaskState.Completed) {
            
        }
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
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        var header = tableViewHeader( headerFrame: CGRectMake(0, 0, tableView.bounds.size.width, 30), textFrame: CGRectMake(20, 5, tableView.bounds.size.width - 20 - 10, 15) )
        
        switch( section )
        {
        case 0:
            header.setText( "Active" )
            break
        case 1:
            header.setText( "Muted" )
            break
        case 2:
            header.setText( "New" )
            break
        default:
            header.setText( "" )
        }
        
        return header
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc : NotifcationController! = self.storyboard?.instantiateViewControllerWithIdentifier("Notifications") as NotifcationController
        //self.presentViewController(vc as UITableViewController, animated: false, completion: nil)
        
        switch( indexPath.section ) {
        case 0:
            vc.notificationStream = active[ indexPath.row ]
            break
        case 1:
            vc.notificationStream = self.muted[ indexPath.row ]
            break
        case 2:
            vc.notificationStream = self.newStreams[ indexPath.row ]
            break
        default:
            println("Error, section not found in didSelectRowAtIndexPath")
        }
        
        self.navigationController?.pushViewController(vc as UITableViewController, animated: true)
    }

    func addStream() {
        
        var addCategoryAlert = UIAlertController(title: "Add Hashtag", message: "Please enter the hashtag:", preferredStyle: UIAlertControllerStyle.Alert)
        addCategoryAlert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default,
            handler: {(alertAction:UIAlertAction!) in
                let textField = addCategoryAlert.textFields![0] as UITextField
                self.addCategory(textField.text)} ))
        addCategoryAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        addCategoryAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter hashtag"
            textField.secureTextEntry = false
        })
        self.presentViewController(addCategoryAlert, animated: true, completion: nil)
        
    }
    
    func addCategory(categoryToAdd: String)
    {
        println( "Adding: " + categoryToAdd )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStreams()
        println(self.active)
        //self.active = [Stream(title: "Water"), Stream(title: "Fire"), Stream(title: "Air"), Stream(title: "Blue Sky")]
        self.muted = [Stream(title: "Breaking Bad"), Stream(title: "Shows You Don't Even Like"),Stream(title: "Funny") ]
        self.newStreams = [Stream(title: "WompWompWomp"), Stream(title: "CatDog"), Stream(title: "The Rains in Africa")]

        //Colors:
        self.view.backgroundColor = self.colors.getCellColor() //background of view
        self.navigationController?.navigationBar.barTintColor = self.colors.getBackGroundColor() //background in nav-bar
        self.navigationController?.navigationBar.tintColor = self.colors.getTextColor() // UIColor.blackColor() //text color in nav-bar
        
        //Navigation Bar:
        self.searchDisplayController?.displaysSearchBarInNavigationBar = true
        
        let rightSideButton: UIBarButtonItem = UIBarButtonItem(title:"Add", style: .Plain, target: self, action: "addStream")
        self.navigationItem.rightBarButtonItem = rightSideButton

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}