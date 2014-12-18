//
//  NotificationClass.swift
//  HiNote
//
//  Created by cameron on 11/7/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation

// Old notification class
// DEPRACATED AFTER ITERATION 5
// REPLACES WITH NOTIFICATIONINFO CLASS
class Notification {
    
    //variables
    var title: String
    var subtitle: String
    
    //emtpy contructor
    init() {
        self.title = "Nothing here"
        self.subtitle = "blank baby blank"
    }
    
    //constructor with string and subtitle
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
}

// Class representing a stream instance
class Stream {
    
    //variables
    var title: String
    var id: Int
    var notifications: [NotificationInfo] = [] //holding all the notifications for this stream
    
    //empty constructor
    init() {
        self.title = "Stream Title Not Initilized"
        self.id = 0
    }
    
    /* 
    * Constructor taking a title and id
    * @param title: the title
    * @param id: the id
    */
    init(title:String, id: Int) {
        self.title = title
        self.id = id
    }
    
    /*
    * Add a notification to the notification list
    * @param toAdd: the notification that needs to be added to the list
    */
    func addNotifications(toAdd: [NotificationInfo]) {
        self.notifications.extend(toAdd)
    }
    
    /*
    * Get a notification at an index
    * @param index: index to get the notification from
    */
    func getNoticationAtIndex( index: Int ) -> NotificationInfo
    {
        if( self.notifications.count < index ) {
            return NotificationInfo()
        }
        
        return self.notifications[ index ]
    }
    
    /*
    * Get the number of notifications currently in the list
    * @return the number of notification currently in the list
    */
    func getNotificationCount() -> Int
    {
        return self.notifications.count
    }
    
    /*
    * Get the all notifications currently in the list
    * @return array of all notifications currently in the list
    */
    func getNotifications() -> [NotificationInfo]
    {
        return self.notifications
    }
    
    /*
    * Get the title of the stream
    * @return the title
    */
    func getTitle() -> String
    {
        return self.title
    }

}