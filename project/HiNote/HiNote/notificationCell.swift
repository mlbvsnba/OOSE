//
//  NotificationCell.swift
//  HiNote
//
//  Created by cameron on 10/30/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit

//Custom cell for the notification view
class NotificationCell: UITableViewCell {
    //let label: UILabel
    var details: NotificationInfo
    let colorScheme: ColorScheme
    
    //default constructors
    override init() {
        //self.label = UILabel()
        self.details = NotificationInfo()
        self.colorScheme = ColorScheme()
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
       // self.label = UILabel()
        self.details = NotificationInfo()
        self.colorScheme = ColorScheme()
        super.init( coder: aDecoder )
    }
    
    override init(frame: CGRect) {
      //  self.label = UILabel()
        self.details = NotificationInfo()
        self.colorScheme = ColorScheme()
        super.init( frame: frame )
    }
    
    /* Custom constructor
    * @param style: the style
    * @param reuseIdentifier: the reuseIdentifier
    * @param info: the info associated with this cell
    */
    init( style: UITableViewCellStyle, reuseIdentifier: String, info: NotificationInfo ) {
        self.details = info
        self.colorScheme = ColorScheme()
        super.init( style: style, reuseIdentifier: reuseIdentifier )
        self.setCellFeatures()
    }
    
    // Set the details part of the notification cell
    func setDetails(info: NotificationInfo) {
        self.details = info
        self.setCellFeatures()
    }
    
    //Get the details of the notificaion cell
    func getDetails() -> NotificationInfo
    {
        return self.details
    }
    
    //Set the features (color and text) of the notification cell
    func setCellFeatures()
    {
        self.textLabel.text = self.details.text
        self.detailTextLabel?.text = self.details.subText
        
        //colors
        self.backgroundColor = self.colorScheme.cellColor
        
    }
}