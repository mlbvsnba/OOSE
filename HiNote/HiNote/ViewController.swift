//
//  ViewController.swift
//  HiNote
//
//  Created by cameron on 10/30/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let buttonToTable = UIButton(frame: CGRectMake(50, 50, 100, 100))
        buttonToTable.titleLabel?.text = "woo"
        buttonToTable.backgroundColor = UIColor.greenColor()
        buttonToTable.addTarget(self, action: "showStream", forControlEvents: .TouchUpInside)
        self.view.addSubview(buttonToTable)
    }
    
    func showStream () {
        let vc : AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("Notifications")
        self.presentViewController(vc as UITableViewController, animated: false, completion: nil)
        println("made it")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

