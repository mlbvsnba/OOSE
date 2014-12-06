//
//  UserSignUp.swift
//  HiNote
//
//  Created by cameron on 11/19/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation

import UIKit



class UserSignUp: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let BOXHEIGHT: CGFloat = 40
        
        let username_banner = UILabel(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.2, self.view.frame.width*0.5, BOXHEIGHT))
        username_banner.text = "Username:"
        
        let password_banner = UILabel(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.4, self.view.frame.width*0.5, BOXHEIGHT))
        password_banner.text = "Password:"
        
        let username_dialog_box = UITextField(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.3, self.view.frame.width*0.5, BOXHEIGHT))
        
        let password_dialog_box = UITextField(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.5, self.view.frame.width*0.5, BOXHEIGHT))
        password_dialog_box.borderStyle = UITextBorderStyle.Line
        username_dialog_box.borderStyle = UITextBorderStyle.Line
        
        let continue_to_stream = UIButton(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.8, self.view.frame.width*0.5, BOXHEIGHT))
        continue_to_stream.addTarget(self, action: "pushNext", forControlEvents: UIControlEvents.TouchUpInside)
        continue_to_stream.setTitle("continue to rest of app", forState: UIControlState.Normal)
        continue_to_stream.setTitleColor(UIColor(white: 0, alpha: 1), forState: UIControlState.Normal)
        
        self.view.addSubview(username_banner)
        
        self.view.addSubview(password_banner)
        
        self.view.addSubview(username_dialog_box)
        
        self.view.addSubview(password_dialog_box)
        
        self.view.addSubview(continue_to_stream)
        continue_to_stream.enabled = true

    }
    func pushNext() {
        let vc : StreamController! = self.storyboard?.instantiateViewControllerWithIdentifier("Streams") as StreamController
        self.navigationController?.pushViewController(vc as UITableViewController, animated: true)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
}