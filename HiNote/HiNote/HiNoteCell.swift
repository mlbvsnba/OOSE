//
//  HiNoteCell.swift
//  HiNote
//
//  Created by matthijs_tas on 12/3/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit

protocol HiNoteCell: UITableViewCell {
    class var label: UILabel{ get }
    class var details: NotificationInfo{ get set }
    
    init()
    
    init(coder aDecoder: NSCoder)
    
    init(frame: CGRect)
    
}