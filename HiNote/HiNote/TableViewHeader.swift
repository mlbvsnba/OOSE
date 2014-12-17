//
//  TableViewHeader.swift
//  HiNote
//
//  Created by matthijs_tas on 11/19/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit

// Class representing a header for each section in the table view
class tableViewHeader: UIView {
    
    // Variables associated with the header
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
    
    /*
    * Custom constructor
    * @param headerFrame: the frame of the header
    * @param textFrame: the text-frame in the header
    */
    init(headerFrame: CGRect, textFrame: CGRect )
    {
        self.label = UILabel( frame: textFrame )
        self.label!.font = UIFont.boldSystemFontOfSize(16.0)
        self.label!.textColor = UIColor.blackColor()
        
        super.init( frame: headerFrame )
        self.backgroundColor = backColor
        
        self.addSubview( self.label! )
    }
    
    /*  
    * Set the text in the header
    * @param text: the text to set
    */
    func setText( text: String )
    {
        if( self.label != nil )
        {
            self.label!.text = text
        }
    }
}