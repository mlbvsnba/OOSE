//
//  UserSignUp.swift
//  HiNote
//
//  Created by cameron on 11/19/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation

import UIKit
import Security



class UserSignUp: UIViewController, UITextFieldDelegate {
    
    var username_dialog_box: UITextField?
    var password_dialog_box: UITextField?
    var name_dialog_box: UITextField?
    var email_dialog_box: UITextField?
    var error_banner: UILabel?
    
    let colors = ColorScheme()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let BOXHEIGHT: CGFloat = 30
        
        let username_banner = UILabel(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1, self.view.frame.width*0.5, BOXHEIGHT))
        username_banner.text = "Username:"
        
        let password_banner = UILabel(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*3, self.view.frame.width*0.5, BOXHEIGHT))
        password_banner.text = "Password:"
        
        let name_banner = UILabel(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*6, self.view.frame.width*0.5, BOXHEIGHT))
        name_banner.text = "Name:"
        
        let email_banner = UILabel(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*9, self.view.frame.width*0.5, BOXHEIGHT))
        email_banner.text = "Email:"
        
        error_banner = UILabel(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*12, self.view.frame.width*0.5, BOXHEIGHT))

        username_dialog_box = UITextField(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*1.5, self.view.frame.width*0.5, BOXHEIGHT))
        
        password_dialog_box = UITextField(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*4.5, self.view.frame.width*0.5, BOXHEIGHT))
        
        name_dialog_box = UITextField(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*7.5, self.view.frame.width*0.5, BOXHEIGHT))
        
        email_dialog_box = UITextField(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*10.5, self.view.frame.width*0.5, BOXHEIGHT))
        
        
        password_dialog_box!.delegate = self
        username_dialog_box!.delegate = self
        name_dialog_box!.delegate = self
        email_dialog_box!.delegate = self
        
        
        password_dialog_box!.borderStyle = UITextBorderStyle.Line
        username_dialog_box!.borderStyle = UITextBorderStyle.Line
        name_dialog_box!.borderStyle = UITextBorderStyle.Line
        email_dialog_box!.borderStyle = UITextBorderStyle.Line
        
        let register = UIButton(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.8, self.view.frame.width*0.5, BOXHEIGHT*2))
        register.addTarget(self, action: "seeIfCanMoveOn", forControlEvents: UIControlEvents.TouchUpInside)
        register.setTitle("Register", forState: UIControlState.Normal)
        register.setTitleColor(UIColor(white: 0, alpha: 1), forState: UIControlState.Normal)
        
        self.view.addSubview(username_banner)
        self.view.addSubview(password_banner)
        self.view.addSubview(name_banner)
        self.view.addSubview(email_banner)
        self.view.addSubview(error_banner!)
        
        self.view.addSubview(username_dialog_box!)
        self.view.addSubview(password_dialog_box!)
        self.view.addSubview(name_dialog_box!)
        self.view.addSubview(email_dialog_box!)
        
        self.view.addSubview(register)
        register.enabled = true

        //set colors
        self.view.backgroundColor = self.colors.getCellColor()
        self.navigationController?.navigationBar.barTintColor = self.colors.getBackGroundColor() //background in nav-bar
        self.navigationController?.navigationBar.tintColor = self.colors.getTextColor() //
        
    }
    
    
    
    
    func pushNext() {
        let vc : StreamController! = self.storyboard?.instantiateViewControllerWithIdentifier("Streams") as StreamController
        self.navigationController?.pushViewController(vc as UITableViewController, animated: true)
    }
    
    func passwordCheck() -> Bool {
        return !(password_dialog_box!.text! == "")
    }
    func userNameCheck() -> Bool {
        return !(username_dialog_box!.text! == "")
    }
    
    func nameCheck() -> Bool {
        return !(username_dialog_box!.text! == "")
    }
    
    func emailCheck() -> Bool {
        //emails have atleast 7 letters
        if(countElements(email_dialog_box!.text!)>7) {
            //has an at symbol
        return (email_dialog_box!.text!.rangeOfString("@") != nil)
        }
        return false
    }
    
    func seeIfCanMoveOn() {
        if (registerForService()) {
            pushNext()
        }
    }
    
    func registerForService() -> Bool {
        if(userNameCheck() && emailCheck() && nameCheck() && passwordCheck()) {
            registerRequest()
            //if it worked return true
            if (self.error_banner!.text != nil){
                return false
                }
            //if not return false
            else {
                
                
                
                return true
            }
        }
        error_banner!.text = "Please Check Boxes"
        return false
    }
    
    
    func registerRequest() {
        let url: String = Constants.baseUrl + "user_signup/"
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var err: NSError?
        
        var bodyData = "username=" + username_dialog_box!.text! + "&password=" +  password_dialog_box!.text! +  "&email=" + email_dialog_box!.text! + "&first_name=" + name_dialog_box!.text! + "&last_name=jameson"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        //request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        //print(request.HTTPBody)
        var task = session.dataTaskWithRequest((request), completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    self.error_banner!.text = nil
                    
                    setPasscode(self.password_dialog_box!.text!)
                    println( "password: \(getPasscode())")
                    setUsername(self.username_dialog_box!.text!)
                    println( "username: \(getUsername())")
                
                    
                    
                    
                    self.registerDeviceToken()
                }
                else if(httpResponse.statusCode == 400) {
                    self.error_banner!.text = "username already registered"
                    //bad request
                }
                 else if(httpResponse.statusCode == 403) {
                    self.error_banner!.text = "invalid username or password"
                }
                else {
                        self.error_banner!.text = "failed to connect to server"
                }
            }
          //println(NSString(data: data, encoding: NSUTF8StringEncoding))
            //println(params)
        })
        task.resume()
    }
    
    func registerDeviceToken() {
        let url: String = Constants.baseUrl + "register_device/"
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var    session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var err: NSError?
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var deviceToken = appDelegate.getDeviceToken()
        
        
        println( "Device toke: \(deviceToken)")
        
        var bodyData = "username=" + username_dialog_box!.text! + "&password=" +  password_dialog_box!.text! +   "&device_token=" + deviceToken
        
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        //request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        //print(request.HTTPBody)
        var task = session.dataTaskWithRequest((request), completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    self.error_banner!.text = nil
                }
                else {
                    self.error_banner!.text = "device cant connect to server"
                    //bad request
                }
            }
        })
        task.resume()
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField!) {    //delegate method
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool {  //delegate method
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
}