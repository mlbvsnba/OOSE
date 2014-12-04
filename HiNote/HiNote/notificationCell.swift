//
//  NotificationCell.swift
//  HiNote
//
//  Created by cameron on 10/30/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit

class NotificationCell: UITableViewCell {
    //let label: UILabel
    var details: NotificationInfo
    let colorScheme: ColorScheme
    
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
    
    init( style: UITableViewCellStyle, reuseIdentifier: String, info: NotificationInfo ) {
        self.details = info
        self.colorScheme = ColorScheme()
        super.init( style: style, reuseIdentifier: reuseIdentifier )
        self.setCellFeatures()
    }
    
    func setDetails(info: NotificationInfo) {
        self.details = info
        self.setCellFeatures()
    }
    
    func getDetails() -> NotificationInfo
    {
        return self.details
    }
    
    func setCellFeatures()
    {
        self.textLabel.text = self.details.text
        self.detailTextLabel?.text = self.details.subText
        
        //colors
        self.backgroundColor = self.colorScheme.cellColor
        
    }
}