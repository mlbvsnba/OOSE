//
//  TestNotifications.swift
//  HiNote
//
//  Created by cameron on 12/5/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//
import HiNote
import XCTest

class TestNotifications: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStreamInstatiantes() {
        let streamForTest = Stream(title: "one stream to rule them all")
        for i in 0 ... 10 {
            var note = Notification(title: "Test", subtitle: "all tests")
            streamForTest.addNotifications([NotificationInfo(dev: "cam cam", notificationText: "red blue green", notificationUrl: "yahoo.com",
                notificationTime: NSDate() )])
        }
        XCTAssertEqual(streamForTest.getNotificationCount(), 10, "notifications aren't being added correctly")
        XCTAssertEqual(streamForTest.title, "one stream to rule them all", "title isn't saved")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
