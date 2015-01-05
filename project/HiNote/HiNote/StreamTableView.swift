//
//  StreamTableView.swift
//  HiNote
//
//  Created by cameron on 10/30/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// Class representing the TableView with streams.
class StreamController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, NSURLConnectionDelegate, CLLocationManagerDelegate  {
    
    var active: [Stream] = []   //holds all the streams the user signed up for
    var otherStreams: [Stream] = [] //holds all the other streams to which the user can sign up

    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchResults: [Stream] = []
    var con: UISearchDisplayController = UISearchDisplayController()
    
    let colors = ColorScheme()
    
    var locationManager: CLLocationManager
    
    var tryingToGetSubscribed: Bool

    /*
    * Returns the cell for the index path in the TableView
    * @param tableview: the tableview
    * @param indexPath: the index in the tableview of the cell
    */
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
        case 1: cell = StreamCell( text: self.otherStreams[ indexPath.row ].title )
            break
        default: cell = StreamCell()
        }
        
        return cell
    }
    
    /*
    * Gets notifications for a stream from the server
    * @param id: the id of the stream
    * @param stream: the stream instance
    */
    func getNotifications(id: String, stream: Stream) {
        let stringURL: String = Constants.baseUrl + "listnotif/?id=" + id
        let url: NSURL = NSURL(string: stringURL)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            var err: NSError?
            let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
            if let notificationArray = jsonObject as? NSArray{
                for notification in notificationArray {
                    println("die here")
                if let streamJSON = notification as? NSDictionary {
                    if let nextJSON = streamJSON["fields"] as? NSDictionary {
                        stream.addNotifications( [NotificationInfo(dev: "Matt", notificationText: nextJSON["contents"]as String!, notificationUrl: nextJSON["url"]as String!, notificationTime: NSDate() )])
                    }
                println("die 2")
                }
                } //dev: String, notificationText: String, notificationUrl: String,
                //notificationTime: NSDate
            }
    })
    task.resume()
    }
    
    /*
    * Gets all streams from the server
    */
    func getStreams() {
        let stringURL: String = Constants.baseUrl + "listall/" //get the URL
        let url: NSURL = NSURL( string: stringURL )!
        let session = NSURLSession.sharedSession()
        
        //make a request
        let task = session.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            var err: NSError?
            
            //get the JSON object
           let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
            if let streamArray = jsonObject as? NSArray{
                
                //loop through all the received streams
                for stream  in streamArray  {
                    if let streamJSON = stream as? NSDictionary {
                        if let nextJSON = streamJSON["fields"] as? NSDictionary {
                            let toAdd = Stream(title: nextJSON["name"]as String!, id: streamJSON["pk"] as Int! )
                            
                            //only add to the section if the user hasn't signed up for it yet
                            if( !self.activeContainsStream( toAdd ) )
                            {
                                self.otherStreams.append(toAdd)
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
    
    /*
    * Check if a stream is in the user's active streams
    * @param check: the stream
    * @return true if it is in it, false otherwise
    */
    func activeContainsStream( check: Stream ) -> Bool {
        for stream in self.active {
            if( stream.getTitle() == check.getTitle() )
            {
                return true
            }
        }
        
        return false
    }
    
    /*
    * Gets all the streams the user is subscribed to from the server
    */
    func getSubscribed()
    {
        //make the url
        let stringURL: String = Constants.baseUrl + "listsubs/"
        var request = NSMutableURLRequest(URL: NSURL(string: stringURL)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var err: NSError?
        
        //create the body data
        var bodyData = "username=" + getUsername() + "&password=" + getPasscode()
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        //make the task
        var task = session.dataTaskWithRequest((request), completionHandler: {data, response, error -> Void in
            let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
            println(jsonObject)
            if let subscribedArray = jsonObject as? NSArray{
                
                //loop through all received streams
                for subscription in subscribedArray {
                    if let streamJSON = subscription as? NSDictionary {
                        if let nextJSON = streamJSON["fields"] as? NSDictionary {
                            let toAdd = Stream(title: nextJSON["name"]as String!, id: streamJSON["pk"] as Int!)
                            self.active.append(toAdd)
                            if let id = streamJSON["pk"] as? Int {
                                self.getNotifications(String(id), stream: toAdd)
                            }
                            
                        }
                    }
                } //dev: String, notificationText: String, notificationUrl: String,
                //notificationTime: NSDate
            }
        })
        task.resume()
        while (task.state != NSURLSessionTaskState.Completed) {
            
        }
        
        //set flag to false
        self.tryingToGetSubscribed = false
    }
    
    /*
    * Filter contents in the tableView for searching
    * @param searchText: the text inputted in the searchBar
    */
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.searchResults = (self.active + self.otherStreams ).filter({( stream: Stream) -> Bool in
            let stringMatch = stream.title.rangeOfString(searchText)
            return (stringMatch != nil)
        })
    }
    
    /*
    * Delegate Function: controls the starting of the search
    */
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    /*
    * Delegate Function: controls the starting of the search
    */
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    /*
    * Delegate Function: returns the number of rows in the tableview per section.
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  tableView == self.searchDisplayController!.searchResultsTableView {
            return self.searchResults.count
        }
        if section == 0 {
            return active.count
        }
        if section == 1 {
            return otherStreams.count
        }
        return 0
    }
    
    /*
    * Delegate Function: returns the number of sections in the tableview
    */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if  tableView == self.searchDisplayController!.searchResultsTableView {
            return 1
        }
        return 2
    }
    
    /*
    * Delegate Function: gets the headers for the sections in the tableview.
    */
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if  tableView == self.searchDisplayController!.searchResultsTableView {
            return "Found"
        }
        
        if section == 0 {
            return "Subscribed"
        }
        else if section == 1 {
            return "Other Streams"
        }
        return ""
    }
    
    /*
    * Delegate Function: creates the view for the headers in the tableview
    */
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        var header = tableViewHeader( headerFrame: CGRectMake(0, 0, tableView.bounds.size.width, 30), textFrame: CGRectMake(20, 5, tableView.bounds.size.width - 20 - 10, 15) )
        
        if( tableView == self.searchDisplayController!.searchResultsTableView ) {
            header.setText( "Found" )
            return header
        }

        
        switch( section )
        {
        case 0:
            header.setText( "Subscribed" )
            break
        case 1:
            header.setText( "Other Streams" )
            break
        default:
            header.setText( "" )
        }
        
        return header
    }
    
    /*
    * Delegate Function: when a row is clicked, this functions is called.
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //switch over the section
        if( indexPath.section == 0 ) {//go the the notification view
            let vc : NotifcationController! = self.storyboard?.instantiateViewControllerWithIdentifier("Notifications") as NotifcationController
            vc.notificationStream = active[ indexPath.row ]
            self.navigationController?.pushViewController(vc as UITableViewController, animated: true)
        }
        else if( indexPath.section ==  1) { //add the stream to active stream
            addStreamToActive( self.otherStreams[ indexPath.row ] )
        }
        else {
            println("Error, section not found in didSelectRowAtIndexPath")
        }
    }
    
    /*
    * Adds a stream to active
    * @param streamToAdd: the stream to add.
    */
    func addStreamToActive( streamToAdd: Stream )
    {
        let stringURL: String = Constants.baseUrl + "subscribe/"
        var request = NSMutableURLRequest(URL: NSURL(string: stringURL)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var err: NSError?
        
        var bodyData = "username=" + getUsername() + "&password=" + getPasscode() + "&sub_id=" + String(streamToAdd.id)
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        var task = session.dataTaskWithRequest((request), completionHandler: {data, response, error -> Void in
            /*
            let vc : StreamController! = self.storyboard?.instantiateViewControllerWithIdentifier("Streams") as StreamController
            self.navigationController?.pushViewController(vc as UITableViewController, animated: true)
            */
        })
        task.resume()
        while (task.state != NSURLSessionTaskState.Completed) {
            
        }

        self.clearArrays()
        self.tryingToGetSubscribed = true
        self.getSubscribed()
        
        while( self.tryingToGetSubscribed )
        {
            //wait here until we finished getting all the subscribed notifications.
        }
        
        self.getStreams()
        
        self.tableView.reloadData()
    }
    
    /*
    * Clear all the streams currently in the tableview.
    */
    func clearArrays() {
        self.active.removeAll(keepCapacity: false)
        self.otherStreams.removeAll(keepCapacity: false)
    }
    
    // OLD FUNCTION
    /*
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
    */
    
    /*
    * Constructor using a coder.
    */
    required init(coder aDecoder: NSCoder) {
        self.locationManager = CLLocationManager()
        self.tryingToGetSubscribed =  true
        super.init( coder: aDecoder )
        //fatalError("init(coder:) has not been implemented")
    }
    
    /*
    * When app loads this function is called.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tryingToGetSubscribed = true
        
        getSubscribed()
        
        while( tryingToGetSubscribed )
        {
            //wait
        }
        
        getStreams()

        
        //Location:
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
        
        //Colors:
        self.view.backgroundColor = self.colors.getCellColor() //background of view
        self.navigationController?.navigationBar.barTintColor = self.colors.getBackGroundColor() //background in nav-bar
        self.navigationController?.navigationBar.tintColor = self.colors.getTextColor() // UIColor.blackColor() //text color in nav-bar
        
        //Navigation Bar:
        self.searchDisplayController?.displaysSearchBarInNavigationBar = true
        
        //OLD RIGHT SIDE BUTTON
        //let rightSideButton: UIBarButtonItem = UIBarButtonItem(title:"Add", style: .Plain, target: self, action: "addStream")
        //self.navigationItem.rightBarButtonItem = rightSideButton

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Location Delegate    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        print( error )
    }
    
    /*
    * If location is updated, this function is called.
    */
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var pastLocations = locations as NSArray
        var currentLocation = pastLocations.lastObject as CLLocation
        var coord = currentLocation.coordinate
    }
    
}