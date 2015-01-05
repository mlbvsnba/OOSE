//
//  StreamCell.swift
//  HiNote
//
//  Created by matthijs_tas on 12/4/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit

// Class representing a cell of a stream in the tableview
class StreamCell: UITableViewCell {
    
    let colorScheme = ColorScheme()
    
    //default constructors:
    override init() {
        super.init()
    }
    
    override  init(#style: UITableViewCellStyle,
        #reuseIdentifier: String?)    {
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
    
    //custom constructor that takes in the text to display.
    init(text: String) {
        super.init()
        self.textLabel.text = text
        self.backgroundColor = self.colorScheme.getCellColor()
    }
}