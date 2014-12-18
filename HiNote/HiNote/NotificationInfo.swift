//
//  NotificationInfo.swift
//  HiNote
//
//  Created by matthijs_tas on 12/3/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation

// Class representing the notification information per notification
class NotificationInfo {
    
    //Variables
    let developer: String
    let text: String
    let subText: String
    
    let url: String
    
    let time: NSDate
    
    // Empty constructor
    init()
    {
        self.developer = ""
        self.text = ""
        self.subText = ""
        self.url = "about:blank"
        self.time = NSDate()
    }
    
    /* Custom constructor
    * @param dev: the develor
    * @param notificationText: the notification text
    * @param notiicationURL: the notification URL
    * @param notificationTime: the time of the notification
    */
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
    
    /*
    * Get the URL related to this info
    * @return the url
    */
    func getUrl() -> String
    {
        return self.url
    }
    
}