//
//  NotificationClass.swift
//  HiNote
//
//  Created by cameron on 11/7/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation

class Notification {
    var title: String
    var subtitle: String
    init() {
        self.title = "Nothing here"
        self.subtitle = "blank baby blank"
    }
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
}

class Stream {
    var title: String
    var notifications: [NotificationInfo] = []
    init() {
        self.title = "Stream Title Not Initilized"
    }
    init(title:String) {
        self.title = title
    }
    func addNotifications(toAdd: [NotificationInfo]) {
        self.notifications.extend(toAdd)
    }
    
    func getNoticationAtIndex( index: Int ) -> NotificationInfo
    {
        if( self.notifications.count < index ) {
            return NotificationInfo()
        }
        
        return self.notifications[ index ]
    }
    
    func getNotificationCount() -> Int
    {
        return self.notifications.count
    }
    
    func getNotifications() -> [NotificationInfo]
    {
        return self.notifications
    }
    
    func getTitle() -> String
    {
        return self.title
    }

}