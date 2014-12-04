//
//  NotificationStream.swift
//  HiNote
//
//  Created by matthijs_tas on 12/4/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation

class NotificationStream {
    var title: String
    var notifications: [NotificationInfo] = []
    
    init() {
        self.title = "Stream Title Not Initilized"
    }
    
    init(title: String) {
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
}