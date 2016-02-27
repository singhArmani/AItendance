 //
//  RegisterViewController.swift
//  SampleBeaconCheckIn
//
//  Created by simranjeet on 14/02/2016.
//  Copyright © 2016 singh. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!

    @IBOutlet weak var userRepeatPassTextField: UITextField!
    
    var  succesfullyRegistered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the delegates as self
        userEmailTextField.delegate = self
        userPasswordTextField.delegate = self
        userRepeatPassTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signUp() {
        
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let repeatPassword = userRepeatPassTextField.text
        
        
        // checking for empty values 
        
        if(userEmail!.isEmpty || userPassword!.isEmpty || repeatPassword!.isEmpty)
        {
            //show alert message 
            alertMessages("All Fields are required")
            return
        }
        
        if(userPassword != repeatPassword)
        {
            //show alert message 
            alertMessages("password do not match")
            return
        }
        
        //store data via calling web Api
        
        saveUser(userEmail!,password: userPassword!);
        
        //display message
        
        let myAlert = UIAlertController(title: "Alert", message: "Registration Successfull!", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK'", style: UIAlertActionStyle.Default){action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        
        
    }
    
    
    
    func alertMessages(userAlertMessages:String)
    {
        let myAlert = UIAlertController(title: "Alert", message: userAlertMessages, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction)
        
        
        //showing up the alert
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    func saveUser(email:String, password:String)
    {
        //splitting the string
         let stringCompArray = email.componentsSeparatedByString("@")
         let studentID = stringCompArray[0]
        
        
        //lets use our web service to save the device UUID to the server
        //start request
        let url:NSURL = NSURL(string: "http://ait.interactivehippo.com.au/advancedstudio2/mobileapp/ios/register.php")!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        
        //device ID can be acquired by called UIDevice.currentDevice().identifierForVendor!.UUIDString
        let deviceID = UIDevice.currentDevice().identifierForVendor!.UUIDString
         let bodyData = "userEmail="+email+"&"+"userPassword="+password+"&"+"deviceUID="+deviceID+"&"+"studentNo="+studentID
        
        
        request.HTTPMethod = "POST"

        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                
                data, response, error in
                
                
                if(data!.length > 0 && error == nil ){
                    do
                    {
                        if let jsonResult  = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                        {
                            print("successfully parsed")
                            let result = jsonResult.objectForKey("success") as? Int64
                            if(result == 1)
                            {
                                print("new registration")
                               // self.succesfullyRegistered = true  this is delaying when response comes back
                            }
                            else
                            {
                                print("already registered")
                            }
                            
                        }
                        else {
                            let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            print("Error could not parse JSON: \(jsonStr)")
                            
                        }
                        
                        
                    }
                    catch let parseError
                    {
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == userEmailTextField){
            userPasswordTextField.becomeFirstResponder()
        }
        else if(textField == userPasswordTextField){
            userPasswordTextField.resignFirstResponder()
        }
        else
        {
            userRepeatPassTextField.resignFirstResponder()
        }
        return true
    }
    
    
    @IBAction func haveAccount() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
