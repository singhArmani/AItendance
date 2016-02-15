//
//  ViewController.swift
//  SampleBeaconCheckIn
//
//  Created by simranjeet on 14/02/2016.
//  Copyright © 2016 singh. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var userEmailTextField: UITextField!

    @IBOutlet weak var userPassword: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.userEmailTextField.delegate = self
        self.userPassword.delegate = self
    }

    
    
    @IBAction func login() {
        
        
        let Email = userEmailTextField.text
        let Password = userPassword.text

        //checking if fields are not empty 
        
        if(Email!.isEmpty || Password!.isEmpty)
        {
            //show alert message
            alertMessages("All Fields are required")
            return
        }

        
        
        //making a call to web api and reterieve the result as json object
        
        //lets use our web service to save the device UUID to the server
        //start request
        let url:NSURL = NSURL(string: "http://192.168.1.7/selectuser.php")!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        
        //device ID can be acquired by called UIDevice.currentDevice().identifierForVendor!.UUIDString
        let deviceID = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let bodyData = "userEmail="+Email!+"&"+"userPassword="+Password!+"&"+"deviceUID="+deviceID
        
        
        request.HTTPMethod = "POST"
        
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                
                data, response, error in
                
               // NSLog(response!.description)
                
                guard let _ = data else {
                    print("Error: did not receive data")
                    return
                }
                guard error == nil else {
                    print("error calling GET on /posts/1")
                    print(error)
                    return
                }
                
                
              //  var jsonResult:NSDictionary
                
                if(data!.length > 0 && error == nil ){
                    do
                    {
                        if let jsonResult  = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                        {
                            print("successfully parsed")
                            let result = jsonResult.objectForKey("email") as? String
                            if(result != "notRegistered")
                            {
                                //login successfull and storing the boolean value true
                               NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                               NSUserDefaults.standardUserDefaults().setObject(result, forKey: "loggedInUserEmail")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                            else
                            {
                                print("Not registered")
                            }
                            
                        }
                        else {
                            let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            print("Error could not parse JSON: \(jsonStr)")
                            
                        }

                        
//                      let result = jsonResult.objectForKey("email") as! String
//                      if(result != "no result")
//                      {
//                         print("success")
//                      }
                    }
                    catch let parseError {
                        print(parseError)
                        let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("Error can't parse JSON: '\(jsonStr)'")
                        
                    }
                   }
                
                if error != nil
                {
                    print("error = \(error)")
                    return
                }
                
                
        }
        
        dataTask.resume()

        
        
        
        
    }
    
    func alertMessages(userAlertMessages:String)
    {
        let myAlert = UIAlertController(title: "Alert", message: userAlertMessages, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction)
        
        
        //showing up the alert
     self.presentViewController(myAlert, animated: true, completion: nil)
        
    }


    
    //textfield delagation 
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if(textField == userEmailTextField)
        {
            userPassword.becomeFirstResponder()
        }
        else
        {
            userPassword.resignFirstResponder()
        }
        return true
    }
    
    
    }

