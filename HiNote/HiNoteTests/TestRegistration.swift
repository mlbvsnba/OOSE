//
//  TestRegistration.swift
//  HiNote
//
//  Created by cameron on 12/5/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import HiNote
import XCTest

class TestRegistration: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInstnatiation() {
        // This is an example of a functional test case.
        let signup = UserSignUp()
        XCTAssertNil(signup.error_banner, "banner is not nil")
        XCTAssertNil(signup.email_dialog_box, "email is not nil")
        XCTAssertNil(signup.username_dialog_box, "username is not nil")
         XCTAssertNil(signup.password_dialog_box, "password is not nil")
         XCTAssertNil(signup.name_dialog_box, "name is not nil")
         XCTAssertNil(signup.email_dialog_box, "email is not nil")
         XCTAssertNil(signup.error_banner, "error banner is not nil")
    }
    
    func testErrorBox() {
        let signup = UserSignUp()
        signup.viewDidLoad()
        XCTAssertNil(signup.error_banner?.text, "banner is not nil")
        XCTAssertFalse(signup.registerForService(), "signup shouldn't complete but does")
        XCTAssertNotNil(signup.error_banner?.text, "banner is still nil even after failure")
        
    }
    
    func testRegistration() {
        let signup = UserSignUp()
        signup.viewDidLoad()
        XCTAssertFalse(signup.registerForService(), "signup shouldn't complete but does")
        
        XCTAssertFalse(signup.emailCheck(), "email shouldnt pass is null")
        signup.email_dialog_box?.text = "coleary9@jhu.edu"
        XCTAssertTrue(signup.emailCheck(), "email should pass doesn't")
        
        XCTAssertFalse(signup.nameCheck(), "name shouldnt pass is null")
        signup.name_dialog_box?.text = "cam"
        XCTAssertTrue(signup.emailCheck(), "name should pass doesn't")
        
        XCTAssertFalse(signup.userNameCheck(), "username shouldnt pass is null")
        signup.username_dialog_box?.text = "cameroni"
        XCTAssertTrue(signup.userNameCheck(), "name should pass doesn't")
        
        XCTAssertFalse(signup.passwordCheck(), "username shouldnt pass is null")
        signup.password_dialog_box?.text = "fish"
        XCTAssertTrue(signup.passwordCheck(), "name should pass doesn't")
        
        XCTAssertTrue(signup.registerForService(), "signup should complete but doesn't")

        
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
