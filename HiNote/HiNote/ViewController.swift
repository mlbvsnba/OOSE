//
//  ViewController.swift
//  HiNote
//
//  Created by cameron on 10/30/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Notifications is the table view of notificaitons for a stream
        //Streams is the table view of streams
        let buttonToNotifications = UIButton(frame: CGRectMake(50, 50, 250, 100))
        buttonToNotifications.setTitle("Notifications Menu", forState: .Normal)
        buttonToNotifications.setTitleColor(UIColor.blackColor(), forState: .Normal)
        buttonToNotifications.backgroundColor = UIColor.greenColor()
        buttonToNotifications.addTarget(self, action: "showNotifications", forControlEvents: .TouchUpInside)
        self.view.addSubview(buttonToNotifications)
        
        let buttonToStream = UIButton()
        buttonToStream.enabled = true
        buttonToStream.setTitle("stream Menu", forState: .Normal)
        buttonToStream.setTitleColor(UIColor.blackColor(), forState: .Normal)
        buttonToStream.backgroundColor = UIColor.redColor()
        buttonToStream.addTarget(self, action: "showStream", forControlEvents: .TouchUpInside)
        buttonToStream.frame = CGRectMake(50, 200, 250, 100)
        self.view.addSubview(buttonToStream)
        getJson()
        
        
    }
    
    func getJson () {
        let url = NSURL(string: "http://mlbvsnba.no-ip.org/oose/sample_notification.json")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()
    }
    
    func showStream () {
        let vc : AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("Streams")
        self.presentViewController(vc as UITableViewController, animated: false, completion: nil)
        println("made it")
    }
    
    func showNotifications() {
        let vc : AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("Notifications")
        self.presentViewController(vc as UITableViewController, animated: false, completion: nil)
        println("made it")
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

