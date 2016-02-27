//
//  AttendanceViewController.swift
//  SampleBeaconCheckIn
//
//  Created by simranjeet on 14/02/2016.
//  Copyright © 2016 singh. All rights reserved.
//

import UIKit

class AttendanceViewController: UIViewController, BCMicroLocationManagerDelegate {
    
    
    @IBOutlet weak var welcome: UILabel!

    @IBOutlet weak var regionStatus: UILabel!
    //Beacon functionality
    
    var AITBCLocationManager = BCMicroLocationManager.sharedManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AITBCLocationManager.delegate = self; //setting this controller as the delegate
        
        AITBCLocationManager.startUpdatingMicroLocation()

        
}

    
    //lets do some delegation
    //! implies “this might trap,” while ? indicates “this might be nil.”
    //this is equivilant to didStartMoniterForSite
    func microLocationManager(microLocationManager: BCMicroLocationManager!, didUpdateMicroLocations microLocations: [AnyObject]!)
    {
        
        
        let beaconNSArray = (microLocations.last as! BCMicroLocation).beacons()  //getting the NSArray* returned from the beacons() of BCMircroLocation instance after type casting)
        
        
        for beacon in beaconNSArray
        {
            print("Beacon: \(beacon.serialNumber) from Site:\(beacon.siteName) ranged  with minor value :\(beacon.minor) and major value: \(beacon.major)")
            
        }
        self.requestStateForNearbySites()
        
    }
    
    
    //wou can also force iOS to call the didDetermineState with the current state by using beacon manager’s nearbySites method
    //getting  nearby sites
    func requestStateForNearbySites()
    {
        let nearbySites = self.AITBCLocationManager.nearbySites
        
        for site in nearbySites
        {
            self.AITBCLocationManager.requestStateForSite(site as! BCSite)
        }
    }
    
    
    //Monitoring Enter Site
    func microLocationManager(microLocationManager: BCMicroLocationManager!, didEnterSite site: BCSite!)
    {
        
      //notification on Entering
        let notification = UILocalNotification.init()
        notification.alertBody = "Welcome to the AITendance project presentation. We are pleased to have you as our special guest.Hope you find it good! "
        // notification.alertAction = "Details"
        notification.soundName = UILocalNotificationDefaultSoundName
        
        
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
        
        //Start ranging now as user has entered into the site region
        self.AITBCLocationManager.startRangingBeaconsInSite(site)
    }
    
    
    //Exiting the Site
    func microLocationManager(microLocationManager: BCMicroLocationManager!, didExitSite site: BCSite!)
    {
       
        let notification = UILocalNotification.init()
        notification.alertBody = "Thanks for being our special guest.Hope you have liked our presentaion. See you again and have a good day!"
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
        regionStatus.text = "See Ya Again!"
        
        //stop ranging for beacons
        self.AITBCLocationManager.stopRangingBeaconsInSite(site)
        self.AITBCLocationManager.stopMonitoringAllSites()
        
        //delete the attendance record as tell that your checkout has been notified
        let email = NSUserDefaults.standardUserDefaults().stringForKey("loggedInUserEmail")
        deleteAttendance(email!)

        
    }

    
    //When Beacons are found
    func microLocationManager(microLocationManager: BCMicroLocationManager!, didRangeBeacons beacons: [AnyObject]!, inSite site: BCSite!)
    {
        
        
        
        let  myBeacon = beacons.last as! BCBeacon
        
        if(myBeacon.proximity == BCProximityNear)
        {
            regionStatus.text = "Good to See Ya!"
            
            
            //make the attendace here only
            // call the web service
            //store the record in the attendance table
            let isLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
            if(isLoggedIn)
            {
                //getting the stored email when user logged in
                  let email = NSUserDefaults.standardUserDefaults().stringForKey("loggedInUserEmail")
                
                //getting the time of checkIN
                let date = NSDate()
                let formatter = NSDateFormatter()
                formatter.timeStyle = .ShortStyle
                formatter.dateStyle = .ShortStyle
                let stringDate = formatter.stringFromDate(date)
                 markAttendance(email!,date: stringDate)
            }
            
            //send a local notification for saying that your checkIn has been notified.

        }
        
        
    }
    
    func markAttendance(email:String, date:String)
    {
        //splitting the string
        let stringCompArray = email.componentsSeparatedByString("@")
        let studentID = stringCompArray[0]
        
        //call to webservice for marking attendance
        //lets use our web service to save the device UUID to the server
        //start request
        let url:NSURL = NSURL(string: "http://ait.interactivehippo.com.au/advancedstudio2/mobileapp/ios/insertAttendance.php")!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
      
        let bodyData = "studentID="+studentID
        
        request.HTTPMethod = "POST"
        
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                
                data, response, error in
                
                if error != nil
                {
                    print("error = \(error)")
                    return
                }
                
                
        }
        
        dataTask.resume()
        
    }
    
    func deleteAttendance(email:String)
    {
        //splitting the string
        let stringCompArray = email.componentsSeparatedByString("@")
        let studentID = stringCompArray[0]
        
        //call to webservice for deleting attendance when user leaves the site
      
        //start request
        let url:NSURL = NSURL(string: "http://ait.interactivehippo.com.au/advancedstudio2/mobileapp/ios/deleteAttendance.php")!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        
        let bodyData = "studentID="+studentID
        
        request.HTTPMethod = "POST"
        
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                
                data, response, error in
                
                if error != nil
                {
                    print("error = \(error)")
                    return
                }
                
                
        }
        
        dataTask.resume()
        
    }
    

    @IBAction func logout(sender: UIButton) {
        
        //once user tap logout button
        //set bool values for isUserLoggedIn to false
       NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
           NSUserDefaults.standardUserDefaults().synchronize()
        
        //stop moniterin beacon upon logout(optional)
        //stop ranging for beacons
        
        
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
