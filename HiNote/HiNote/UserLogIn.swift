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

// Class representing the LogIn page of the user
class UserLogIn: UIViewController, UITextFieldDelegate {
    
    // Variables
    var username_dialog_box: UITextField?
    var password_dialog_box: UITextField?
    var error_banner: UILabel?
    
    let colors = ColorScheme()
    
    
    // When the view loads, this is called
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let BOXHEIGHT: CGFloat = 30
        
        
        //Set all boxes and titles
        let username_banner = UILabel(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1, self.view.frame.width*0.5, BOXHEIGHT))
        username_banner.text = "Username:"
        
        let password_banner = UILabel(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*3, self.view.frame.width*0.5, BOXHEIGHT))
        password_banner.text = "Password:"
        
        error_banner = UILabel(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*12, self.view.frame.width*0.5, BOXHEIGHT))
        
        username_dialog_box = UITextField(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*1.5, self.view.frame.width*0.5, BOXHEIGHT))
        
        password_dialog_box = UITextField(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.1 + BOXHEIGHT*4.5, self.view.frame.width*0.5, BOXHEIGHT))
        
        // set delegates to self
        password_dialog_box!.delegate = self
        username_dialog_box!.delegate = self

        // set style
        password_dialog_box!.borderStyle = UITextBorderStyle.Line
        username_dialog_box!.borderStyle = UITextBorderStyle.Line

        // create login button
        let logIn = UIButton(frame: CGRectMake(self.view.frame.width*0.25, self.view.frame.height*0.75, self.view.frame.width*0.5, BOXHEIGHT*2))
        logIn.addTarget(self, action: "seeIfCanMoveOn", forControlEvents: UIControlEvents.TouchUpInside)
        logIn.setTitle("Log In", forState: UIControlState.Normal)
        logIn.setTitleColor(UIColor(white: 0, alpha: 1), forState: UIControlState.Normal)
        
        //create register button
        let register = UIButton(frame: CGRectMake(self.view.frame.width*0.166, self.view.frame.height*0.85, self.view.frame.width*0.66, BOXHEIGHT*2))
        register.addTarget(self, action: "registerUser", forControlEvents: UIControlEvents.TouchUpInside)
        register.setTitle("Register As A New User", forState: UIControlState.Normal)
        register.setTitleColor(UIColor(white: 0, alpha: 1), forState: UIControlState.Normal)
        
        // add the buttons to the subview
        self.view.addSubview(username_banner)
        self.view.addSubview(password_banner)

        self.view.addSubview(error_banner!)
        
        self.view.addSubview(username_dialog_box!)
        self.view.addSubview(password_dialog_box!)

        self.view.addSubview( logIn )
        self.view.addSubview( register )
        
        //enable the log in
        logIn.enabled = true
        register.enabled = true
        
        //set colors
        self.view.backgroundColor = self.colors.getCellColor()
        self.navigationController?.navigationBar.barTintColor = self.colors.getBackGroundColor() //background in nav-bar
        self.navigationController?.navigationBar.tintColor = self.colors.getTextColor() //
        
        // check if the username and password are empty. If so, get them from the KeyChain (auto-log-in after already having logged in sometime)
        if(!(getUsername() == "") || (getPasscode() == "")) {
            username_dialog_box!.text! = getUsername()
            password_dialog_box!.text = getPasscode()
            seeIfCanMoveOn()
        }
        
    }
    
    /*
    * Open up the register user page
    */
    func registerUser () {
        //go to the register user page
        let vc : UserSignUp! = self.storyboard?.instantiateViewControllerWithIdentifier("FromLogIn") as UserSignUp
        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
    }
    
    /*
    * If logged in succesfully, go to the streamview table
    */
    func pushNext() {
        let vc : StreamController! = self.storyboard?.instantiateViewControllerWithIdentifier("Streams") as StreamController
        self.navigationController?.pushViewController(vc as UITableViewController, animated: true)
    }
    
    /*
    * Check if the password is non-empty
    * @return: true if non-empty
    */
    func passwordCheck() -> Bool {
        return !(password_dialog_box!.text! == "")
    }
    
    /*
    * Check if the name is non-empty
    * @return: true if non-empty
    */
    func userNameCheck() -> Bool {
        return !(username_dialog_box!.text! == "")
    }
    
    /*
    * Check if the we can move on to the next page, that is, when logging in worked
    */
    func seeIfCanMoveOn() {
        if (registerForService()) {
            pushNext()
        }
    }
    
    /*
    * Register the user (as a Log In) with the server
    * @return: true if success
    */
    func registerForService() -> Bool {
        if(userNameCheck() && passwordCheck()) {
            login()
            //if it worked return true
            if (self.error_banner!.text != nil){
                return false
            }
            //if not return false, then logging in must've succeeded
            else {
                return true
            }
        }
        error_banner!.text = "Please Check Boxes"
        return false
    }
    
    /*
    * Log in with the server
    */
    func login() {
        
        //Create URL
        let url: String = Constants.baseUrl + "check_auth/"
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var err: NSError?
        
        // Make Request Body
        var bodyData = "username=" + username_dialog_box!.text! + "&password=" +  password_dialog_box!.text!

        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        //Catch response from the server
        var task = session.dataTaskWithRequest((request), completionHandler: {data, response, error -> Void in
            
            //Deal with appropriate response
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
    
    // Delegate method
    func textFieldDidBeginEditing(textField: UITextField!) {    //delegate method
    }
    
    // Delegate method
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool {  //delegate method
        return true
    }
    
    // Delegate method
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Delegate method
    override func resignFirstResponder() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
}