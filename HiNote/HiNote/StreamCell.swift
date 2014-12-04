//
//  StreamCell.swift
//  HiNote
//
//  Created by matthijs_tas on 12/4/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit

class StreamCell: UITableViewCell {
    
    let colorScheme = ColorScheme()
    
    override init() {
        super.init()
    }
    
    override  init(style style: UITableViewCellStyle,
        reuseIdentifier reuseIdentifier: String?)    {
        super.init( style: style, reuseIdentifier: reuseIdentifier )
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init( coder: aDecoder )
        self.backgroundColor = self.colorScheme.getCellColor()
    }
    
    override init(frame: CGRect) {
        super.init( frame: frame )
        self.backgroundColor = self.colorScheme.getCellColor()
    }
    
    init(text: String) {
        super.init()
        self.textLabel.text = text
        self.backgroundColor = self.colorScheme.getCellColor()
    }
}