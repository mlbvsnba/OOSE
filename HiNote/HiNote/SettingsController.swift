//
//  SettingsController.swift
//  HiNote
//
//  Created by cameron on 11/1/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit

//
//  StreamTableView.swift
//  HiNote
//
//  Created by cameron on 10/30/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit

class SettingsController: UITableViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            if indexPath.row == 0 {
            cell.textLabel.text = "Unlimited"
            let UnlimitedOnOff: UISwitch  = UISwitch();
            cell.accessoryView = UnlimitedOnOff;
            }
            else if indexPath.row == 1 {
                cell.textLabel.text = "Max Daily Notifications"
                let count: UILabel = UILabel(frame: CGRectMake(0, 0, 40, 40))
                count.text = "20"
                cell.accessoryView = count
            }
            
        }
        else if indexPath.section == 1 {
            let LocationOnOff: UISwitch  = UISwitch();
            cell.accessoryView = LocationOnOff;
            cell.textLabel.text = "Allow Location Based Notifications"
        }
        else {
            let MuteOnOff: UISwitch  = UISwitch();
            cell.accessoryView = MuteOnOff;
            cell.textLabel.text = "Mute"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Notification Frequency"
        }
        if section == 1 {
            return "location"
        }
        return "Sounds"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 20))
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}