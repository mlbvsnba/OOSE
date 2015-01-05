//
//  StreamTableView.swift
//  HiNote
//
//  Created by cameron on 10/30/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit

//Class representing the settings page
class SettingsController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate   {
    
    // Possibe options for frequency
    let FREQUENCY_DATA = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    let FREQUENCY_TAG = 99
    let count: UITextField = UITextField(frame: CGRectMake(0, 0, 40, 40))
    
    let colors = ColorScheme()
    
    //Switches
    var unlimitedOnOff: UISwitch
    var locationOnOff: UISwitch
    var muteOnOff: UISwitch
    
    var picker: UIPickerView

    /* Required constructor */
    required init(coder aDecoder: NSCoder) {
        self.unlimitedOnOff = UISwitch()
        self.locationOnOff = UISwitch()
        self.muteOnOff = UISwitch()
        self.picker = UIPickerView()
        super.init( coder: aDecoder )
    }
    
    /* TableView Functions */
    /*
    * TableView delegate: make cell for each section in the tableview
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.backgroundColor = self.colors.getCellColor()
        
        //Figure out what section
        if indexPath.section == 0 { //FREQUENCY SECTION
            if indexPath.row == 0 {
                cell.textLabel.text = "Unlimited"
                
                //create switch
                self.unlimitedOnOff  = UISwitch();
                self.unlimitedOnOff.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
                cell.accessoryView = self.unlimitedOnOff;
            }
            else if indexPath.row == 1 {
                cell.textLabel.text = "Max Daily Notifications"
                
                //Create Picker
                self.picker = UIPickerView()
                
                self.picker.dataSource = self
                self.picker.delegate = self
                
                count.tag = FREQUENCY_TAG
                count.inputView = picker
                
                count.text = "20"
                cell.accessoryView = count
            }
            
        }
        else if indexPath.section == 1 { //LOCATION SECTION
            //Create switch for Location
            self.locationOnOff  = UISwitch();
            self.locationOnOff.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
            cell.accessoryView = self.locationOnOff;
            cell.textLabel.text = "Allow Location Based Notifications"
        }
        else { //MUTE SECTION
            //create switch
            self.muteOnOff = UISwitch();
            self.muteOnOff.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
            cell.accessoryView = self.muteOnOff;
            cell.textLabel.text = "Mute"
        }
        return cell
    }
    
    /*
    * TableView delegate: number of rows (cells) in a section in the tableview
    */
    override func tableView( tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    
    /*
    * TableView delegate: number of sections in the tableview
    */
    override func numberOfSectionsInTableView( tableView: UITableView ) -> Int {
        return 3
    }
    
    /*
    * TableView delegate: create the title for each section in the table view
    */
    override func tableView( tableView: UITableView, titleForHeaderInSection section: Int ) -> String? {
        if section == 0 {
            return "Notification Frequency"
        }
        if section == 1 {
            return "Location"
        }
        return "Sounds"
    }
    
    /*
    * TableView delegate: create the actual header for each section in the tableview
    */
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
    /*
    * Picker delegate: number of components in the picker
    */
    func numberOfComponentsInPickerView( pickerView: UIPickerView ) -> Int {
        return 1
    }
    
    /*
    * TableView delegate: number of rows in the picker
    */
    func pickerView( pickerView: UIPickerView, numberOfRowsInComponent component: Int ) -> Int {
        return FREQUENCY_DATA.count
    }
    
    /*
    * TableView delegate: make title for row in the picker
    */
    func pickerView( pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int ) -> String! {
        return FREQUENCY_DATA[ row ]
    }
    
    /*
    * TableView delegate: when a row in the picker is selected
    */
    func pickerView( pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int ) {
        self.count.text = FREQUENCY_DATA[ row ]
    }
    
    /*
    * When app has loaded, this function is called.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 0)  )
        
        //colors
        self.view.backgroundColor = self.colors.getCellColor()
        
        self.navigationController?.navigationBar.barTintColor = self.colors.getBackGroundColor()
        self.navigationController?.navigationBar.tintColor = self.colors.getTextColor() //text color in nav-bar

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    * Function when any switch is changed, update the settings and the page
    */
    func stateChanged(switchState: UISwitch) {
        if( self.unlimitedOnOff.on )
        {
            //Unlimited is on
            self.count.text = "∞"
            self.picker.userInteractionEnabled = false
        } else {
            self.count.text = "20"
            self.picker.userInteractionEnabled = true
        }
        
    }
    
}