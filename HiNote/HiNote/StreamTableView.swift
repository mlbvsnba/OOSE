//
//  StreamTableView.swift
//  HiNote
//
//  Created by cameron on 10/30/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit

class StreamController: UITableViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
        cell.textLabel.text = "#baltimore"
        }
        else {
            cell.textLabel.text = "#America"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
        return "Active"
        }
        return "Muted"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc : AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("Notifications")
        //self.presentViewController(vc as UITableViewController, animated: false, completion: nil)
        self.navigationController?.pushViewController(vc as UITableViewController, animated: true)
    }
    func addStream() {
       println("add")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightSideButton: UIBarButtonItem = UIBarButtonItem(title:"Add", style: .Plain, target: self, action: "addStream")
        self.navigationItem.rightBarButtonItem = rightSideButton
        self.tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 20))
        println(self.tableView.tableHeaderView?.frame)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}