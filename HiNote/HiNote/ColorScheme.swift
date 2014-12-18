//
//  ColorScheme.swift
//  HiNote
//
//  Created by matthijs_tas on 12/4/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit


// uninary class representing the colors of the app
class ColorScheme {
    let backGroundColor: UIColor
    let cellColor: UIColor
    let textColor: UIColor
    
    //Constructor
    init()
    {
        self.backGroundColor = UIColor(red: CGFloat(108/255.0), green: CGFloat(172/255.0), blue: CGFloat(178/255.0), alpha: CGFloat(1.0))
        self.cellColor = UIColor(red: CGFloat(200/255.0), green: CGFloat(228/255.0), blue: CGFloat(224/255.0), alpha: CGFloat(1.0))
        self.textColor = UIColor.blackColor()
    }
    
    //Getter for the background color
    func getBackGroundColor() -> UIColor {
        return self.backGroundColor
    }
    
    //Getter for the cell color
    func getCellColor() -> UIColor {
        return self.cellColor
    }
    
    //Getter for the text color
    func getTextColor() -> UIColor {
        return self.textColor
    }
}