//
//  TableViewHeader.swift
//  HiNote
//
//  Created by matthijs_tas on 11/19/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit

class tableViewHeader: UIView {
    let label: UILabel?
    let backColor: UIColor = UIColor(red: CGFloat(108/255.0), green: CGFloat(172/255.0), blue: CGFloat(178/255.0), alpha: CGFloat(1.0))
    
    override init() {
        self.label = UILabel()
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        self.label = UILabel()
        super.init()
    }
    
    init(headerFrame: CGRect, textFrame: CGRect )
    {
        self.label = UILabel( frame: textFrame )
        self.label!.font = UIFont.boldSystemFontOfSize(16.0)
        self.label!.textColor = UIColor.blackColor()
        
        super.init( frame: headerFrame )
        self.backgroundColor = backColor
        
        self.addSubview( self.label! )
    }
    
    func setText( text: String )
    {
        if( self.label != nil )
        {
            self.label!.text = text
        }
    }
}