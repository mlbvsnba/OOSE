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

class SettingsController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate   {
    
    let FREQUENCY_DATA = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    let FREQUENCY_TAG = 99
    let count: UITextField = UITextField(frame: CGRectMake(0, 0, 40, 40))
    
    let colors = ColorScheme()
    
    var backColor: UIColor = UIColor(red: CGFloat(108/255.0), green: CGFloat(172/255.0), blue: CGFloat(178/255.0), alpha: CGFloat(1.0))
    var cellColor: UIColor = UIColor(red: CGFloat(200/255.0), green: CGFloat(228/255.0), blue: CGFloat(224/255.0), alpha: CGFloat(1.0))
    
    /* TableView Functions */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.backgroundColor = self.colors.getCellColor()
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
            cell.textLabel.text = "Unlimited"
            let UnlimitedOnOff: UISwitch  = UISwitch();
            cell.accessoryView = UnlimitedOnOff;
            }
            else if indexPath.row == 1 {
                cell.textLabel.text = "Max Daily Notifications"
                
                
                let picker: UIPickerView = UIPickerView()
                
                picker.dataSource = self
                picker.delegate = self
                
                count.tag = FREQUENCY_TAG
                count.inputView = picker
                
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
    
    override func tableView( tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    
    override func numberOfSectionsInTableView( tableView: UITableView ) -> Int {
        return 3
    }
    
    
    override func tableView( tableView: UITableView, titleForHeaderInSection section: Int ) -> String? {
        if section == 0 {
            return "Notification Frequency"
        }
        if section == 1 {
            return "Location"
        }
        return "Sounds"
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        var header = tableViewHeader( headerFrame: CGRectMake(0, 0, tableView.bounds.size.width, 30), textFrame: CGRectMake(20, 5, tableView.bounds.size.width - 20 - 10, 15) )
        
        switch( section )
        {
        case 0:
            header.setText( "Notification Frequency" )
            break
        case 1:
            header.setText( "Location" )
            break
        default:
            header.setText( "Sounds" )
        }
        
        return header
    }
    
    /* PickerView functions */
    //Data Sources
    
    func numberOfComponentsInPickerView( pickerView: UIPickerView ) -> Int {
        return 1
    }
    
    func pickerView( pickerView: UIPickerView, numberOfRowsInComponent component: Int ) -> Int {
        return FREQUENCY_DATA.count
    }
    
    //Delegates
    func pickerView( pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int ) -> String! {
        return FREQUENCY_DATA[ row ]
    }
    
    func pickerView( pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int ) {
        self.count.text = FREQUENCY_DATA[ row ]
        //TODO: forward to server side
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 0)  )
        
        //colors
        self.view.backgroundColor = self.colors.getCellColor()
        
        self.navigationController?.navigationBar.barTintColor = self.colors.getBackGroundColor()
        self.navigationController?.navigationBar.tintColor = self.colors.getTextColor() //text color in nav-bar
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}