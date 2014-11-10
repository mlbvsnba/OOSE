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
    var Notifications: [Notification] = []
    init() {
        self.title = "Stream Title Not Initilized"
    }
    init(title:String) {
        self.title = title
    }
    func addNotifications(toAdd: [Notification]) {
        self.Notifications.extend(toAdd)
    }
}