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

class StreamController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, NSURLConnectionDelegate, CLLocationManagerDelegate  {
    
    var active: [Stream] = []
    var otherStreams: [Stream] = []
    //var newStreams: [Stream] = []
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchResults: [Stream] = []
    var con: UISearchDisplayController = UISearchDisplayController()
    
    let colors = ColorScheme()
    
    var locationManager: CLLocationManager

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
    
    func getNotifications(id: String, stream: Stream) {
        let stringURL: String = Constants.baseUrl + "listnotif/?id=" + id
        let url: NSURL = NSURL(string: stringURL)!
        let session = NSURLSession.sharedSession()
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
        self.searchResults = (self.active + self.otherStreams ).filter({( stream: Stream) -> Bool in
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
            return otherStreams.count
        }
        return 0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if  tableView == self.searchDisplayController!.searchResultsTableView {
            return 1
        }
        return 2
    }
    
    
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.presentViewController(vc as UITableViewController, animated: false, completion: nil)
        
        switch( indexPath.section ) {
        case 0:
            let vc : NotifcationController! = self.storyboard?.instantiateViewControllerWithIdentifier("Notifications") as NotifcationController
            vc.notificationStream = active[ indexPath.row ]
            self.navigationController?.pushViewController(vc as UITableViewController, animated: true)
            break
        case 1:
            addStreamToActive( self.otherStreams[ indexPath.row ] )
            break
        default:
            println("Error, section not found in didSelectRowAtIndexPath")
        }
    }
    
    func addStreamToActive( streamToAdd: Stream )
    {
        println( "Added following stream: " + streamToAdd.getTitle() )
    }

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
    
    required init(coder aDecoder: NSCoder) {
        self.locationManager = CLLocationManager()
        super.init( coder: aDecoder )
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStreams()
        println(self.active)
        //self.active = [Stream(title: "Water"), Stream(title: "Fire"), Stream(title: "Air"), Stream(title: "Blue Sky")]
        self.otherStreams = [Stream(title: "Breaking Bad"), Stream(title: "Shows You Don't Even Like"),Stream(title: "Funny") ]

        
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
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //println("updated location")
        
        var pastLocations = locations as NSArray
        var currentLocation = pastLocations.lastObject as CLLocation
        var coord = currentLocation.coordinate
            
        println(coord.latitude)
        println(coord.longitude)
        
        //TODO: get location to server side
    }
    
    /*
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
            }
            NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
            if (shouldIAllow == true) {
                NSLog("Location to Allowed")
                // Start location services
                locationManager.startUpdatingLocation()
            } else {
                NSLog("Denied access: \(locationStatus)")
            }
    }
    */
    
    
}