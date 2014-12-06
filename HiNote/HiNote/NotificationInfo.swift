//
//  NotificationInfo.swift
//  HiNote
//
//  Created by matthijs_tas on 12/3/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation

class NotificationInfo {
    let developer: String
    let text: String
    let subText: String
    
    let url: String
    
    let time: NSDate
    
    init()
    {
        self.developer = ""
        self.text = ""
        self.subText = ""
        self.url = "about:blank"
        self.time = NSDate()
    }
    
    init( dev: String, notificationText: String, notificationUrl: String,
        notificationTime: NSDate )
    {
        self.developer = dev
        self.text = notificationText
        self.url = notificationUrl
        self.time = notificationTime
        
        var timeDescription: String = self.time.description
        timeDescription.substringWithRange(Range<String.Index>(start: advance(timeDescription.startIndex, 0),
            end: advance(timeDescription.endIndex, -6))) //truncate time zone off
        
        self.subText = self.developer + " at " + timeDescription
    }
    
    func getUrl() -> String
    {
        return self.url
    }
    
}