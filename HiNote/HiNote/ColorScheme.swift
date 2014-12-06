//
//  ColorScheme.swift
//  HiNote
//
//  Created by matthijs_tas on 12/4/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation
import UIKit

class ColorScheme {
    let backGroundColor: UIColor
    let cellColor: UIColor
    let textColor: UIColor
    
    init()
    {
        self.backGroundColor = UIColor(red: CGFloat(108/255.0), green: CGFloat(172/255.0), blue: CGFloat(178/255.0), alpha: CGFloat(1.0))
        self.cellColor = UIColor(red: CGFloat(200/255.0), green: CGFloat(228/255.0), blue: CGFloat(224/255.0), alpha: CGFloat(1.0))
        self.textColor = UIColor.blackColor()
    }
    
    func getBackGroundColor() -> UIColor {
        return self.backGroundColor
    }
    
    func getCellColor() -> UIColor {
        return self.cellColor
    }
    
    func getTextColor() -> UIColor {
        return self.textColor
    }
}