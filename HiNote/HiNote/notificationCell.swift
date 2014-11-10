//
//  notificationCell.swift
//  HiNote
//
//  Created by cameron on 10/30/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit

class NotificationCell: UITableViewCell {
    let label = UILabel()
    
    override init() {
        super.init()
        label.text = "woo"
        self.addSubview(label)
    }

    required init(coder aDecoder: NSCoder) {
        super.init()
        label.text = "woo"
        self.addSubview(label)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.text = "woo"
        self.addSubview(label)
    }
    
}