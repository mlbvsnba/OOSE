//
//  UserLogIn.swift
//  HiNote
//
//  Created by matthijs_tas on 12/16/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import Foundation

import UIKit
import Security


class UserLogIn: UIViewController, UITextFieldDelegate {
    
    var username_dialog_box: UITextField?
    var password_dialog_box: UITextField?
    var error_banner: UILabel?
    
    let colors = ColorScheme()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let BOXHEIGHT: CGFloat = 30
        
        let username_banner = UILabel(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1, self.view.frame.width*0.5, BOXHEIGHT))
        username_banner.text = "Username:"
        
        let password_banner = UILabel(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*3, self.view.frame.width*0.5, BOXHEIGHT))
        password_banner.text = "Password:"
        
        
        error_banner = UILabel(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*12, self.view.frame.width*0.5, BOXHEIGHT))
        
        username_dialog_box = UITextField(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*1.5, self.view.frame.width*0.5, BOXHEIGHT))
        
        password_dialog_box = UITextField(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*4.5, self.view.frame.width*0.5, BOXHEIGHT))
        
        
        password_dialog_box!.delegate = self
        username_dialog_box!.delegate = self

        
        
        password_dialog_box!.borderStyle = UITextBorderStyle.Line
        username_dialog_box!.borderStyle = UITextBorderStyle.Line

        
        let logIn = UIButton(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.6, self.view.frame.width*0.5, BOXHEIGHT*2))
        logIn.addTarget(self, action: "seeIfCanMoveOn", forControlEvents: UIControlEvents.TouchUpInside)
        logIn.setTitle("Log In", forState: UIControlState.Normal)
        logIn.setTitleColor(UIColor(white: 0, alpha: 1), forState: UIControlState.Normal)
        
        let register = UIButton(frame: CGRectMake(self.view.frame.width*0.166, self.view.frame.height*0.7, self.view.frame.width*0.66, BOXHEIGHT*2))
        register.addTarget(self, action: "registerUser", forControlEvents: UIControlEvents.TouchUpInside)
        register.setTitle("Register As A New User", forState: UIControlState.Normal)
        register.setTitleColor(UIColor(white: 0, alpha: 1), forState: UIControlState.Normal)
        
        self.view.addSubview(username_banner)
        self.view.addSubview(password_banner)

        self.view.addSubview(error_banner!)
        
        self.view.addSubview(username_dialog_box!)
        self.view.addSubview(password_dialog_box!)

        
        self.view.addSubview( logIn )
        self.view.addSubview( register )
        
        logIn.enabled = true
        register.enabled = true
        
        //set colors
        self.view.backgroundColor = self.colors.getCellColor()
        self.navigationController?.navigationBar.barTintColor = self.colors.getBackGroundColor() //background in nav-bar
        self.navigationController?.navigationBar.tintColor = self.colors.getTextColor() //
        
        if(!(getUsername() == "") || (getPasscode() == "")) {
            username_dialog_box!.text! = getUsername()
            password_dialog_box!.text = getPasscode()
            seeIfCanMoveOn()
        }
        
    }
    
    
    func registerUser () {
        let vc : UserSignUp! = self.storyboard?.instantiateViewControllerWithIdentifier("FromLogIn") as UserSignUp
        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
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
    
    func seeIfCanMoveOn() {
        if (registerForService()) {
            pushNext()
        }
    }
    
    func registerForService() -> Bool {
        if(userNameCheck() && passwordCheck()) {
            login()
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
    
    
    func login() {
        let url: String = Constants.baseUrl + "check_auth/"
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var err: NSError?
        
        var bodyData = "username=" + username_dialog_box!.text! + "&password=" +  password_dialog_box!.text!

        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        //request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        //print(request.HTTPBody)
        var task = session.dataTaskWithRequest((request), completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    self.error_banner!.text = nil
                }

                else if (httpResponse.statusCode == 403) {
                    self.error_banner!.text = "invalid username or password"
                }
                else {
                    self.error_banner!.text = "failed to connect to server"
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