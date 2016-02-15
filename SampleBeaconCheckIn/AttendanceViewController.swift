//
//  AttendanceViewController.swift
//  SampleBeaconCheckIn
//
//  Created by simranjeet on 14/02/2016.
//  Copyright © 2016 singh. All rights reserved.
//

import UIKit

class AttendanceViewController: UIViewController {
    
    
    @IBOutlet weak var welcome: UILabel!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
}

    

    @IBAction func logout(sender: UIButton) {
        
        //once user tap logout button
        //set bool values for isUserLoggedIn to false
       NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
           NSUserDefaults.standardUserDefaults().synchronize()
           self.performSegueWithIdentifier("loginView", sender: self)
    }

    
    
    override func viewWillAppear(animated: Bool) {
        let email = NSUserDefaults.standardUserDefaults().stringForKey("loggedInUserEmail")
        if((email == nil)){
            welcome.text = "Welcome"
        }
        else
        {
            welcome.text = "Welcome "+"\(email!)"
        }

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        
        //only shows the login View when user is not logged in. 
        if(!isUserLoggedIn)
        {
         self.performSegueWithIdentifier("loginView", sender: self)
        }
       
    }

}
